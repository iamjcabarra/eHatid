//
//  DeliveryCell.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import SDWebImage
import SnapKit
import UIKit

public class DeliveryCell: UITableViewCell {

    // MARK: - Subviews
    private let goodsImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = UIView.ContentMode.scaleToFill
        return view
    }()

    private let senderLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = UIColor.clear
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    private let receiverLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = UIColor.clear
        view.textAlignment = NSTextAlignment.left
        return view
    }()
    
    private let totalFeeLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = ThemeManager.currentTheme().titleTextFont
        view.textAlignment = NSTextAlignment.right
        view.textColor = ThemeManager.currentTheme().titleTextColor
        return view
    }()
    
    private let favoriteImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = UIView.ContentMode.scaleToFill
        view.image = #imageLiteral(resourceName: "HeartIcon")
        return view
    }()
    
    private let containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = ThemeManager.currentTheme().navigationBarTintColor.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 3.0
        return view
    }()

    // MARK: - Initializers
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = UIColor.clear
        self.selectionStyle = SelectionStyle.none
        
        self.contentView.subview(forAutoLayout: self.containerView)
        
        self.containerView.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(16.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview()
        }

        self.containerView.subviews(forAutoLayout: [
            self.goodsImageView, self.senderLabel,
            self.receiverLabel, self.totalFeeLabel,
            self.favoriteImageView
        ])

        self.goodsImageView.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(100.0)
        }

        self.senderLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalTo(self.goodsImageView.snp.trailing).offset(8.0)
            make.trailing.equalTo(self.favoriteImageView.snp.leading).inset(-8.0)
            make.height.equalTo(25.0)
        }
        
        self.receiverLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.senderLabel.snp.bottom).offset(8.0)
            make.leading.equalTo(self.goodsImageView.snp.trailing).offset(8.0)
            make.trailing.equalTo(self.totalFeeLabel.snp.leading).inset(-8.0)
            make.height.equalTo(25.0)
        }
        
        self.favoriteImageView.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.width.equalTo(25.0)
            make.height.equalTo(25.0)
        }

        self.totalFeeLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.senderLabel.snp.bottom).offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.width.equalTo(75.0)
            make.height.equalTo(25.0)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Public APIs
extension DeliveryCell {
    public static var identifier: String = "DeliveryCell"
    
    /// Binds delivery details to reusable `DeliveryCell`.
    ///
    /// - Parameter delivery: An instance of `LocalDelivery`
    /// - Returns: None
    public func configure(delivery: LocalDelivery) {
        guard
            let goodsPicture = delivery.goodsPicture,
            let sender = delivery.sender,
            let senderName = sender.name
        else {
            logger.error("Delivery details contain nil property.")
            return
        }
        
        let localizedFromString: String = NSLocalizedString("From", comment: "")
        self.senderLabel.text = "\(localizedFromString): \(senderName)"
        self.senderLabel.highlight(
            searchedText: "\(localizedFromString):",
            color: ThemeManager.currentTheme().titleTextColor,
            font: ThemeManager.currentTheme().titleTextFont
        )
        
        let localizedToString: String = NSLocalizedString("To", comment: "")
        self.receiverLabel.text = "\(localizedToString): \(receiverName)"
        self.receiverLabel.highlight(
            searchedText: "\(localizedToString):",
            color: ThemeManager.currentTheme().titleTextColor,
            font: ThemeManager.currentTheme().titleTextFont
        )
        
        self.totalFeeLabel.text = delivery.totalFee?.toCurrency()
        self.goodsImageView.sd_setImage(with: URL(string: "\(goodsPicture)"), placeholderImage: #imageLiteral(resourceName: "ImagePlaceholder"))
        self.favoriteImageView.isHidden = delivery.isFavorite ? false : true
    }
    
}
