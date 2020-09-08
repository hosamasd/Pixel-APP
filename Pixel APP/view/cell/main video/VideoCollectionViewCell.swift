//
//  VideoCollectionViewCell.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: BaseCollectionCell {
    
    
    var data:VideoModel?{
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
       
       lazy var overView: UIView = {
           let v = UIView()
           v.backgroundColor = .black
           v.layer.cornerRadius = 8
           v.alpha = 0.5
           return v
       }()
       
       lazy var playBtnView: UIImageView = {
           let img = UIImageView()
           img.image = UIImage(named: "play-button")
           img.translatesAutoresizingMaskIntoConstraints = false
        img.constrainWidth(constant: 50)
        img.constrainHeight(constant: 50)
           return img
       }()
       
       lazy var durationLabel: UILabel = {
           let l = UILabel()
           l.text = "0:13"
           l.font = UIFont.systemFont(ofSize: 14)
           l.textColor = .white
           l.translatesAutoresizingMaskIntoConstraints = false
           return l
       }()
    
    override func setupView() {
        addSubViews(views: playBtnView)
        stack(imgView)
        
        playBtnView.centerInSuperview()
        stack(UIView(),hstack(UIView(),durationLabel)).withMargins(.allSides(16))
        
                
             
        
    }
    
    func manageData(){
        guard let data = data else {return}
        imgView.cacheImageWithLoader(withURL: data.src?.original ?? "", view: backView)
        guard let interval = data.duration else { return }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let formattedString = formatter.string(from: TimeInterval(interval))!
        durationLabel.text = formattedString
    }
    
}


