//
//  DeliveryVC.swift
//  eHatid
//
//  Created by Julius Abarra on 2/12/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import CoreData
import KRProgressHUD
import UIKit

public final class DeliveryVC: UIViewController {

    // MARK: - Initializers
    public init(viewModel: DeliveryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    public override func loadView() {
        super.loadView()
        self.view = DeliveryView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar title
        self.title = NSLocalizedString("Deliveries", comment: "")
        
        // Hide spinner by default
        self.rootView.spinner(isHidden: true)
        
        // Configure table view
        self.rootView.tableView.register(DeliveryCell.self, forCellReuseIdentifier: DeliveryCell.identifier)
        self.rootView.tableView.dataSource = self
        self.rootView.tableView.delegate = self
        
        // Request for delivery list
        self.fetchDeliveries(isLoadMore: false)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadFetchedResultsController()
    }
    
    // MARK: - Stored Properties
    private var viewModel: DeliveryViewModel
    private var offset: Int = 1
    private let limit: Int = 10
    private var isLoadingMore: Bool = false
    private var _fetchedResultsController: NSFetchedResultsController<NSManagedObject>?

}

// MARK: - Root View
extension DeliveryVC {
    public var rootView: DeliveryView { return self.view as! DeliveryView } // swiftlint:disable:this force_cast
}

// MARK: - Utility Methods
extension DeliveryVC {

    private func fetchDeliveries(isLoadMore: Bool) {
        isLoadMore ? self.hideTableFooterView(false) : KRProgressHUD.show()
        
        if isLoadMore == false {
            self.viewModel.database.clearEntity(name: Constants.Entity.delivery, filteredBy: nil)
            self.viewModel.database.clearEntity(name: Constants.Entity.deliverySender, filteredBy: nil)
            self.viewModel.database.clearEntity(name: Constants.Entity.deliveryRoute, filteredBy: nil)
        }
        
        self.viewModel.getDeliveries(offset: self.offset, limit: self.limit) { result in
            switch result {
            case .success(let isSuccess):
                DispatchQueue.main.async { [weak self] in
                    isLoadMore ? self?.hideTableFooterView(true) : KRProgressHUD.dismiss()
                    
                    if isSuccess {
                        self?.reloadFetchedResultsController()
                        self?.offset += 1
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    let message: String = NSLocalizedString(
                        "Sorry but there was an error processing your request.",
                        comment: ""
                    )
                    KRProgressHUD.showMessage(message)
                    self?.hideTableFooterView(true)
                    logger.error("\(error)")
                }
            }
        }
    }
    
    private func hideTableFooterView(_ hide: Bool) {
        self.isLoadingMore = hide ? false : true
        self.rootView.spinner(isHidden: hide)
    }

}

// MARK: - UITableViewDataSource Methods
extension DeliveryVC: UITableViewDataSource {
    
    public func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        guard let sectionCount = self.fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let sectionData = self.fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DeliveryCell.identifier,
                for: indexPath) as? DeliveryCell,
            let delivery = self.fetchedResultsController.object(at: indexPath) as? LocalDelivery
        else {
            logger.error("Not of type \"DeliveryCell\" or delivery object is nil.")
            return UITableViewCell()
        }
        
        cell.configure(delivery: delivery)
        return cell
    }
    
}

// MARK: - UITableViewDelegate Methods
extension DeliveryVC: UITableViewDelegate {
    
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let delivery = self.fetchedResultsController.object(at: indexPath) as? LocalDelivery else {
            logger.error("Delivery object is nil.")
            return
        }
        
        let detailsViewVC: DeliveryDetailsViewVC = DeliveryDetailsViewVC(delivery: delivery)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItem.Style.plain,
            target: nil,
            action: nil
        )
        self.navigationController?.pushViewController(detailsViewVC, animated: true)
    }
    
    public func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        // If user has reached the bottom and it's not loading more, then load more deliveries.
        if (maximumOffset - currentOffset <= 10.0) && self.isLoadingMore == false {
            self.fetchDeliveries(isLoadMore: true)
        }
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate Methods
extension DeliveryVC: NSFetchedResultsControllerDelegate {
    
    private func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        self.rootView.tableView.beginUpdates()
    }
    
    private func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            self.rootView.tableView.insertSections(IndexSet(integer: sectionIndex), with: UITableView.RowAnimation.fade)
        case .delete:
            self.rootView.tableView.deleteSections(IndexSet(integer: sectionIndex), with: UITableView.RowAnimation.fade)
        default:
            return
        }
    }
    
    private func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                self.rootView.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
        case .delete:
            if let indexPath = indexPath {
                self.rootView.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
        case .update:
            if  let indexPath = indexPath,
                let delivery = self.fetchedResultsController.object(at: indexPath) as? LocalDelivery,
                let cell = self.rootView.tableView.cellForRow(at: indexPath) as? DeliveryCell {
                cell.configure(delivery: delivery)
            }
        case .move:
            if let indexPath = indexPath {
                self.rootView.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
            if let newIndexPath = newIndexPath {
                self.rootView.tableView.insertRows(at: [newIndexPath], with: UITableView.RowAnimation.fade)
            }
        }
    }
    
    private func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        self.rootView.tableView.endUpdates()
    }
    
}

// MARK: - NSFetchedResultsController Helpers
extension DeliveryVC {
    
    private var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        guard let ctx = self.viewModel.database.mainContext else {
            fatalError("Can't retrieve the main context.")
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(
            entityName: Constants.Entity.delivery
        )
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let frc: NSFetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: ctx,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc.delegate = self
        
        _fetchedResultsController = frc
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    private func reloadFetchedResultsController() {
        self._fetchedResultsController = nil
        self.rootView.tableView.reloadData()
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch let error as NSError {
            logger.error("\(error.localizedDescription)")
        }
    }
    
}
