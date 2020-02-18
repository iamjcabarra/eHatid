//
//  DeliveryDetailsView.swift
//  eHatid
//
//  Created by Julius Camba Abarra on 2/17/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import SDWebImage
import SnapKit
import UIKit

public final class DeliveryDetailsView: UIView {
    
    // MARK: - Subviews
    private let fromLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = ThemeManager.currentTheme().titleTextBackgroundColor
        view.numberOfLines = 0
        view.text = NSLocalizedString("From", comment: "")
        return view
    }()
    
    private let actualFromLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        return view
    }()
    
    private let toLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = ThemeManager.currentTheme().titleTextBackgroundColor
        view.numberOfLines = 0
        view.text = NSLocalizedString("To", comment: "")
        return view
    }()
    
    private let actualToLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        return view
    }()
    
    private let goodsLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = ThemeManager.currentTheme().titleTextBackgroundColor
        view.numberOfLines = 0
        view.text = NSLocalizedString("Goods to deliver", comment: "")
        return view
    }()
    
    private let goodsImageView: UIImageView = {
        let view: UIImageView = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = UIView.ContentMode.scaleToFill
        return view
    }()
    
    private let totalFeeLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = ThemeManager.currentTheme().titleTextBackgroundColor
        view.numberOfLines = 0
        view.text = NSLocalizedString("Delivery Fee", comment: "")
        return view
    }()
    
    private let actualTotalFeeLabel: UILabel = {
        let view: UILabel = UILabel()
        view.backgroundColor = UIColor.clear
        view.numberOfLines = 0
        return view
    }()
    
    public let favoriteButton: UIButton = {
        let view: UIButton = UIButton()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let containerView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private let scrollView: UIView = {
        let view: UIScrollView = UIScrollView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // MARK: - Initializers
    public override init(frame: CGRect) { // swiftlint:disable:this function_body_length
        super.init(frame: frame)
        
        self.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        self.subview(forAutoLayout: self.scrollView)
        
        self.scrollView.snp.remakeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.scrollView.subview(forAutoLayout: self.containerView)
        
        self.containerView.snp.remakeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.containerView.subviews(forAutoLayout: [
            self.favoriteButton, self.fromLabel,
            self.actualFromLabel, self.toLabel,
            self.actualToLabel, self.totalFeeLabel,
            self.actualTotalFeeLabel, self.goodsLabel,
            self.goodsImageView
        ])
        
        self.favoriteButton.snp.remakeConstraints { (make: ConstraintMaker) in
            make.top.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.width.equalTo(30.0)
            make.height.equalTo(30.0)
        }
        
        self.fromLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.favoriteButton.snp.bottom).offset(16.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
        }
        
        self.actualFromLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.fromLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
        }
        
        self.toLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.actualFromLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
        }
        
        self.actualToLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.toLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
        }
        
        self.goodsLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.actualToLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
        }
        
        self.goodsImageView.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.goodsLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.height.equalTo(100.0)
            make.width.equalTo(100.0)
        }
        
        self.totalFeeLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.goodsImageView.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
        }
        
        self.actualTotalFeeLabel.snp.remakeConstraints { [unowned self] (make: ConstraintMaker) in
            make.top.equalTo(self.totalFeeLabel.snp.bottom).offset(8.0)
            make.leading.equalToSuperview().offset(32.0)
            make.trailing.equalToSuperview().inset(32.0)
            make.height.greaterThanOrEqualTo(0.0)
            make.bottom.equalToSuperview()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Public APIs
extension DeliveryDetailsView {
    
    /// Binds delivery details to `DeliveryDetailsView`.
    ///
    /// - Parameter delivery: An instance of `LocalDelivery`
    /// - Returns: None
    public func configure(delivery: LocalDelivery) {
        self.actualFromLabel.text = delivery.sender?.name
        self.actualToLabel.text = receiverName
        self.actualTotalFeeLabel.text = delivery.totalFee?.toCurrency()
        self.configureFavoriteButton(isFavorite: delivery.isFavorite)
        
        guard let goodsPicture = delivery.goodsPicture else {
            logger.error("goodsPicture is nil.")
            return
        }
        self.goodsImageView.sd_setImage(
            with: URL(string: "\(goodsPicture)"),
            placeholderImage: #imageLiteral(resourceName: "ImagePlaceholder")
        )
    }
    
    /// Reconfigures `favoriteButton` looks.
    ///
    /// - Parameter isFavorite: A `Boolean` value
    /// - Returns: None
    public func configureFavoriteButton(isFavorite: Bool) {
        self.favoriteButton.setImage(
            isFavorite ? #imageLiteral(resourceName: "MinusHeart") : #imageLiteral(resourceName: "PlusHeart"),
            for: UIControl.State.normal
        )
    }
    
}
