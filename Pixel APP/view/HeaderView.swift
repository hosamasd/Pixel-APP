//
//  HeaderView.swift
//  Pixel APP
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

struct CategoryData {
    var categoryTitle:String!
    var categoryImage:String!
}

protocol HeaderActionsProtocol {
    func didSearchBarTapped()
    func categoryTapped(_ category:String)
}

class HeaderView:UIView {
    
    var categoryData = [
        CategoryData(categoryTitle: "Sports", categoryImage: "sports"),
        CategoryData(categoryTitle: "Fashion", categoryImage: "fashion"),
        CategoryData(categoryTitle: "Music", categoryImage: "music"),
        CategoryData(categoryTitle: "Nature", categoryImage: "nature"),
        CategoryData(categoryTitle: "Art", categoryImage: "art"),
        CategoryData(categoryTitle: "Architecture", categoryImage: "architecture"),
        CategoryData(categoryTitle: "Food", categoryImage: "food"),
        CategoryData(categoryTitle: "Travel", categoryImage: "travel")
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
    
    lazy var searchLabel = UILabel(text: "Search", font: .systemFont(ofSize: 18), textColor:  UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1))
    
    lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(searchBar), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.register(ImageCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCategoryCollectionViewCell")
        cv.delegate = self
        cv.dataSource = self
        cv.delaysContentTouches = false
        layout.scrollDirection = .horizontal
        cv.setCollectionViewLayout(layout, animated: false)
        cv.constrainHeight(constant: 80)
        return cv
    }()
    
    
    lazy var seperatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.7
        return v
    }()
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [searchLabel,searchImage].forEach{$0.translatesAutoresizingMaskIntoConstraints=false}
        addSubViews(views: searchBarView,collectionView,seperatorView)
        
        stack(searchBarView,collectionView,seperatorView,spacing:8).withMargins(.init(top: 8, left: 0, bottom: 0, right: 0))
        
        //        setUpConstraints()
        
        
    }
    
    func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            searchImage.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            searchButton.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
    }
    
    @objc func searchBar(){
        delegate?.didSearchBarTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCategoryCollectionViewCell", for: indexPath) as! ImageCategoryCollectionViewCell
        cell.data = categoryData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        let font = UIFont.systemFont(ofSize: 23)
        let width = categoryData[indexPath.row].categoryTitle.width(withConstrainedHeight: 60, font: font)
        return CGSize(width: width + 30, height: 60)
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
