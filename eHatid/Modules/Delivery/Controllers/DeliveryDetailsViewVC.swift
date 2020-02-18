//
//  DeliveryDetailsViewVC.swift
//  eHatid
//
//  Created by Julius Camba Abarra on 2/17/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import UIKit

public final class DeliveryDetailsViewVC: UIViewController {

    // MARK: - Initializers
    public init(delivery: LocalDelivery) {
        self.delivery = delivery
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    public override func loadView() {
        super.loadView()
        self.view = DeliveryDetailsView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar title
        self.title = NSLocalizedString("Delivery Details", comment: "")
        
        // Bind delivery details to view
        self.rootView.configure(delivery: self.delivery)
        
        // Handle favorite button action
        self.rootView.favoriteButton.addTarget(
            self,
            action: #selector(self.didTapFavoriteButton),
            for: UIControl.Event.touchUpInside
        )
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Stored Properties
    private var delivery: LocalDelivery

}

// MARK: - Root View
extension DeliveryDetailsViewVC {
    public var rootView: DeliveryDetailsView { return self.view as! DeliveryDetailsView }
}

// MARK: - Target Action Methods
extension DeliveryDetailsViewVC {
   
    @objc private func didTapFavoriteButton() {
        let isFavorite: Bool = !self.delivery.isFavorite
        self.rootView.configureFavoriteButton(isFavorite: isFavorite)
        self.delivery.isFavorite = isFavorite
    }
    
}
