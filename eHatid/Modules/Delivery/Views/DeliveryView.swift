//
//  DeliveryView.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import SnapKit
import UIKit

public final class DeliveryView: UIView {

    // MARK: - Stored Properties
    public let tableView: UITableView = {
        let view: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.clear
        view.allowsMultipleSelection = false
        view.rowHeight = 90.0
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        return view
    }()
    
    public lazy var spinner: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        view.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 44.0)
        view.startAnimating()
        return view
    }()
    
    // MARK: - Initializersf
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        self.subview(forAutoLayout: self.tableView)
        
        self.tableView.snp.remakeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Public APIs
extension DeliveryView {
    
    /// Adds or removes spinner to/from table footer view.
    ///
    /// - Parameter isHidden: Hide or not?
    /// - Returns: None
    public func spinner(isHidden: Bool) {
        self.tableView.tableFooterView = isHidden ? nil : self.spinner
    }
    
}
