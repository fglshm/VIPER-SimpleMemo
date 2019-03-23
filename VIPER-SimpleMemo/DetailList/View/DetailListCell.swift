//
//  DetailListCell.swift
//  VIPER-SimpleMemo
//
//  Created by Shohei Maeno on 2019/03/23.
//  Copyright © 2019 Shohei Maeno. All rights reserved.
//

import UIKit

class DetailListCell: UICollectionViewCell {
    
    var detail: Detail? {
        didSet {
            contentsLabel.text = detail?.contents
        }
    }
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        addSubview(contentsLabel)
        
        contentsLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
