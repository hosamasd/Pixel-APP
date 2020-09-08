//
//  VideoCollectionViewCell.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: BaseCollectionCell {
    
    

var data:String?{
        didSet{
            manageData()
        }
    }
    
     lazy var imgView: CustomImageView = {
        let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue:230/255, alpha: 1).cgColor
        img.layer.borderWidth = 0.5
        img.layer.cornerRadius = 8
        return img
    }()
    
    lazy var backView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 8
        v.alpha = 0.5
        return v
    }()
    
    override func setupView() {
        stack(imgView)
        stack(backView)
        
    }
    
    func manageData(){
        guard let data = data else {return}
        imgView.cacheImageWithLoader(withURL: data, view: backView)
    }
    
}


