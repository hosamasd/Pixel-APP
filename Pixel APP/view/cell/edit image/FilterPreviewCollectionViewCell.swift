//
//  FilterPreviewCollectionViewCell.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class FilterPreviewCollectionViewCell: BaseCollectionCell {
    
    override var isSelected: Bool {
        didSet{
            filteredImage.layer.borderWidth = isSelected ? 3 : 0
            filterName.textColor = isSelected ? .white : .lightGray
        }
    }
    
    lazy var filteredImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "food")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.constrainWidth(constant: 100)
        img.constrainHeight(constant: 100)
        return img
    }()
    
    lazy var filterName:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .lightGray
        l.font = UIFont(name: "Avenir-Medium", size: 14)
        l.text = "Mono"
        l.textAlignment = .center
        return l
    }()
    
    override func setupView() {
        
        addSubViews(views: filteredImage,filterName)
        
        filteredImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        filterName.anchor(top: filteredImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            filteredImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterName.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    
}
