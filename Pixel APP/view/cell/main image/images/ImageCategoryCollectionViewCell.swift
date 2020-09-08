//
//  ImageCategoryCollectionViewCell.swift
//  Pixel APP
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class ImageCategoryCollectionViewCell: BaseCollectionCell {
    
    var data:CategoryData?{
        didSet{
            manageData()
        }
    }
    
    lazy var cellCardView:UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var opaqueView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor(white: 0 , alpha: 0.5)
        return v
    }()
    
    lazy var categoryLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .white
        cl.font = UIFont(name: "Times-Bold", size: 23)
        cl.textAlignment = .center
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
    }()
    
    override func setupView() {
        
        addSubview(cellCardView)
        cellCardView.addSubViews(views: imgView,opaqueView,categoryLabel)
       
        cellCardView.fillSuperview()
        imgView.fillSuperview()
        opaqueView.fillSuperview()
        
        categoryLabel.anchor(top: cellCardView.topAnchor, leading: cellCardView.leadingAnchor, bottom: cellCardView.bottomAnchor, trailing: cellCardView.trailingAnchor,padding: .init(top: 0, left: 15, bottom: 0, right: 15))
       
//        cellCardView.pin(to: self)
//        imgView.pin(to: cellCardView)
//        opaqueView.pin(to: cellCardView)
//        NSLayoutConstraint.activate([
//            categoryLabel.leadingAnchor.constraint(equalTo: cellCardView.leadingAnchor, constant: 15),
//            categoryLabel.trailingAnchor.constraint(equalTo: cellCardView.trailingAnchor, constant: -15),
//            categoryLabel.bottomAnchor.constraint(equalTo: cellCardView.bottomAnchor),
//            categoryLabel.topAnchor.constraint(equalTo: cellCardView.topAnchor)
//        ])
    }
    
    func manageData(){
        guard let data = data else {return}
        categoryLabel.text = data.categoryTitle
        imgView.image = UIImage(named: data.categoryImage)
    }
    


}
