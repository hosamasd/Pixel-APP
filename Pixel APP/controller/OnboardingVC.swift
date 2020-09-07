//
//  OnboardingVC.swift
//  Pixel APP
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController {
    
    
  var dataArr = [
      OnboardingData(image: "graphic1", title: "Explore Images and Videos", subtitle: "Explore large collection of images"),
      OnboardingData(image: "graphic2", title: "Category Search", subtitle: "Search image and videos with category"),
      OnboardingData(image: "graphic3", title: "Download Images and Video", subtitle: "Pick and save image and video to you photoroll"),
  ]
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        layout.scrollDirection = .horizontal
               collectionView.setCollectionViewLayout(layout, animated: false)
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 29/255, green: 212/255, blue: 255/255, alpha: 1)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.constrainHeight(constant: 30)
        return pageControl
    }()
    
    lazy var getStartedButton: UIButton = {
        let btn = UIButton()
        btn.isHide(true)
        btn.setTitle("Get Started", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 29/255, green: 168/255, blue: 255/255, alpha: 1)
        btn.titleLabel?.font = UIFont(name: "Times-Bold", size: 22)
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(getStartedPressed), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.constrainWidth(constant: 170)
        btn.constrainHeight(constant: 50)
        return btn
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubViews(views: pageControl,getStartedButton)
        view.insertSubview(collectionView, belowSubview: pageControl)
        collectionView.fillSuperview()

        pageControl.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 30, right: 0))
        getStartedButton.anchor(top: nil, leading: nil, bottom: pageControl.topAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: -40, right: 0))

        NSLayoutConstraint.activate([
            
            //Btn
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func getStartedPressed(){
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: "onboardingCompletes")
        userDefault.synchronize()
        let vc = ImagesVC()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
}

extension OnboardingVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.data = dataArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        if self.pageControl.currentPage == 2 {
            getStartedButton.isHidden = false
        } else {
            getStartedButton.isHidden = true
        }
    }
    
}

