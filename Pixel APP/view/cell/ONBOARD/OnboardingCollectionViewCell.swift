//
//  OnboardingCollectionViewCell.swift
//  Pixel APP
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: BaseCollectionCell {
    
    
 var data:OnboardingData?{
        didSet{
            manageData()
        }
    }
    
    lazy var graphicImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints=false
        imgView.clipsToBounds=true
        imgView.constrainHeight(constant: frame.height/4)
        return imgView
    }()
    
   lazy var titleLabel:UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Times-Bold", size: 35)
        title.numberOfLines = 0
        title.textAlignment = .center
    title.translatesAutoresizingMaskIntoConstraints=false

        return title
    }()
    
    lazy var subtitleLabel:UILabel = {
        let subtitle = UILabel()
        subtitle.font = UIFont(name: "Times", size: 20)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center
        subtitle.textColor = .lightGray
        subtitle.translatesAutoresizingMaskIntoConstraints=false

        return subtitle
    }()
    
    override func setupView() {
        
        addSubViews(views: graphicImage,titleLabel,subtitleLabel)
        
        titleLabel.anchor(top: graphicImage.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))

        NSLayoutConstraint.activate([
         graphicImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         graphicImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
         subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
          titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
    }
    
    func manageData(){
        guard let data = data else {return}
        graphicImage.image = UIImage(named: data.image)
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
}

