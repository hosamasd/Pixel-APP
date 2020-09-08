//
//  VideoHeaderView.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class VideoHeaderView: UIView {

    var  categoryData = [
                   CategoryData(categoryTitle: "Sports", categoryImage: "sports"),
                   CategoryData(categoryTitle: "Gaming", categoryImage: "gaming"),
                   CategoryData(categoryTitle: "DIY", categoryImage: "DIY"),
                   CategoryData(categoryTitle: "Education", categoryImage: "education"),
                   CategoryData(categoryTitle: "News", categoryImage: "news"),
                   CategoryData(categoryTitle: "Entertainment", categoryImage: "entertainment"),
                   CategoryData(categoryTitle: "Animals", categoryImage: "animals"),
                   CategoryData(categoryTitle: "Food", categoryImage: "food"),
                   CategoryData(categoryTitle: "Travel", categoryImage: "travel"),
                   CategoryData(categoryTitle: "Vehicles", categoryImage: "vehicles"),
                   CategoryData(categoryTitle: "Animations", categoryImage: "animation")
               ]
        var delegate:HeaderActionsProtocol?
        
        lazy var searchBarView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = 5
            view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.hstack(searchButton,searchLabel,spacing:8).withMargins(.allSides(8))
                   view.constrainHeight(constant: 60)
            return view
        }()
        
        lazy var searchImage: UIImageView = {
            let img = UIImageView()
            img.image = UIImage(named: "search")
            img.contentMode = .scaleAspectFit
            return img
        }()
        
        lazy var searchLabel = UILabel(text: "Search", font: UIFont(name: "Times", size: 18), textColor: UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1))
        
        lazy var searchButton: UIButton = {
            let btn = UIButton()
            btn.setTitle("search", for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.addTarget(self, action: #selector(searchBar), for: .touchUpInside)
            btn.constrainWidth(constant: 20)

            
            return btn
        }()
        
        lazy var collectionView: UICollectionView = {
            let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
            cv.showsVerticalScrollIndicator = false
            cv.showsHorizontalScrollIndicator = false
            cv.backgroundColor = .white
            layout.scrollDirection = .horizontal
            cv.setCollectionViewLayout(layout, animated: false)
            cv.delegate = self
            cv.dataSource = self
            cv.register(ImageCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCategoryCollectionViewCell")
            cv.delaysContentTouches = false
            cv.constrainHeight(constant: 80)

            return cv
        }()
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        
        lazy var seperatorView: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.lightGray
            v.alpha = 0.7
            return v
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            setupViews()
         }
    
    func setupViews()  {

        stack(searchBarView,collectionView,seperatorView,spacing:8).withMargins(.init(top: 8, left: 16, bottom: 0, right: 16))

         
        }
        
        @objc func searchBar(){
            delegate?.didSearchBarTapped()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

extension VideoHeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return categoryData.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCategoryCollectionViewCell", for: indexPath) as! ImageCategoryCollectionViewCell
            cell.data = categoryData[indexPath.row]
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            collectionView.contentInset = UIEdgeInsets(top: 17, left: 0, bottom: 17, right: 0)
            let font = UIFont(name: "Times-Bold", size: 23)
            let width = categoryData[indexPath.row].categoryTitle.width(withConstrainedHeight: 60, font: font!)
            return CGSize(width: 120, height: 60)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 15
        }
        
        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                if let cell = collectionView.cellForItem(at: indexPath) as? ImageCategoryCollectionViewCell{
                    cell.cellCardView.transform = .init(scaleX: 0.90, y: 0.90)
                }
            }, completion: { _ in
            })
        }
        
        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                if let cell = collectionView.cellForItem(at: indexPath) as? ImageCategoryCollectionViewCell{
                    cell.cellCardView.transform = .identity
                }
            }, completion: { _ in
            })
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delegate?.categoryTapped(categoryData[indexPath.row].categoryTitle)
        }

    }
