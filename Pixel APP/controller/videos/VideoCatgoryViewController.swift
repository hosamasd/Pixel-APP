//
//  VideoCatgoryViewController.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import AVKit

class VideoCatgoryViewController: UIViewController {
    
    var query = ""
    var FetchedVideos:MainVideosModel?
    var videoList=[VideoModel]()
    var page:Int = 1
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 255/255, alpha: 1)
        layout.scrollDirection = .vertical
        cv.setCollectionViewLayout(layout, animated: false)
        let customLayout = PinterestLayout()
        cv.collectionViewLayout = customLayout
        cv.delegate = self
        cv.dataSource = self
        cv.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        
        return cv
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView()
        aI.style = .large
        aI.color = .darkGray
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupViews()
        setUpNavigationBar()
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        getVideosAndCached()
        ///Assigning Custom layout
        
        activityIndicator.startAnimating()
        
    }
    
    func setupViews()  {
        view.addSubViews(views: collectionView,activityIndicator)
        
        collectionView.fillSuperview()
        
        
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    
    func getVideosAndCached()  {
        
        FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query: "new", perPage: "10", page: "\(page)") { (FetchedImages,err)  in
            guard let FetchedImages=FetchedImages else{return}
            self.FetchedVideos = FetchedImages
            self.getImageArray(FetchedImages)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.collectionView.reloadData()
            }
        }
    }
    
    func getImageArray(_ data:MainVideosModel){
        videoList = data.videos
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    func setUpNavigationBar(){
        navigationItem.title = "\(query)"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Times-Bold", size: 22)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "whiteBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
    }
    
    @objc func backBtn(){
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension VideoCatgoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        cell.data = videoList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //pagination here
        let totalPosts = FetchedVideos?.totalResults
        if indexPath.row == videoList.count - 1{
            if totalPosts! > videoList.count {
                self.page += 1
                
                getVideosAndCached()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell{
                cell.imgView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.backView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.overView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell{
                cell.imgView.transform = .identity
                cell.backView.transform = .identity
                cell.overView.transform = .identity
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoURL = URL(string: videoList[indexPath.row].videoFiles.first?.link ?? "")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

extension VideoCatgoryViewController: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        let cellWidth = (collectionView.frame.width - 44) / 2
        let imageRatio = CGFloat(videoList[indexPath.row].width) / CGFloat(videoList[indexPath.row].height)
        return CGFloat(cellWidth / imageRatio)
        
    }
}
