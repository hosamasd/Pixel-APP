//
//  VideosVC.swift
//  Pixel APP
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class VideosVC: UIViewController {
    
    
 var FetchedVideos:FetchVideoModel?
    var videoList=[VideoModel]()

    var page:Int = 1
    
    lazy var headerView: VideoHeaderView = {
        let view = VideoHeaderView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
               collectionView.showsVerticalScrollIndicator = false
               collectionView.showsHorizontalScrollIndicator = false
               collectionView.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 255/255, alpha: 1)
               layout.scrollDirection = .vertical
               collectionView.setCollectionViewLayout(layout, animated: false)
               let customLayout = PinterestLayout()
               collectionView.collectionViewLayout = customLayout
               collectionView.delegate = self
               collectionView.dataSource = self
               headerView.delegate = self
               collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
               return collectionView
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
               setUpNavigationBar()
               setupViews()
               
               ///Assigning Custom layout
               if let layout = collectionView.collectionViewLayout as? PinterestLayout {
                   layout.delegate = self
               }
               
               collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
               
               getVideosAndCached()
        
        FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query: "new", perPage: "10", page: "1") { (FetchedVideos) in
            self.FetchedVideos = FetchedVideos
            self.getVideoArray(FetchedVideos)
            self.collectionView.reloadData()
        }
    }
    
    func getVideosAndCached()  {
        
    FetchImageModel.fetchImages(url: "\(Constants.BASE_URL)/search", query: "new", perPage: "10", page: "\(page)") { (FetchedImages,err)  in
               guard let FetchedImages=FetchedImages else{return}
               self.FetchedImages = FetchedImages
               self.getImageArray(FetchedImages)
               DispatchQueue.main.async {
                   self.collectionView.reloadData()
               }
           }
       }
       
       func getImageArray(_ data:MainPhotosModel){
           var images = [VideoModel]()
           guard let imgResult = data.photos else {return}
           for i in 0..<imgResult.count{
               let img = PhotoModel(height: imgResult[i].height, photographer: "", url: "", photographerID: 0 , id: imgResult[i].id, liked: false, width: imgResult[i].width, photographerURL: imgResult[i].src?.medium ?? "")
               images.append(img)
           }
           if imageList.count <= 0 {
               imageList = images
           } else {
               imageList.append(contentsOf: images)
           }
       }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
    }
    
    func setUpNavigationBar(){
        navigationController?.navigationBar.topItem?.title = "PIXEL"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = false
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Times-Bold", size: 22)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }

}

extension VideosVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let videoList = videoList {
            return videoList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        cell.data = videoList![indexPath.row]
        
        let totalPosts = FetchedVideos?.totalResults
        if indexPath.row == videoList!.count - 1{
            if totalPosts! > videoList!.count {
                self.page += 1
                FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query:"new", perPage:"10", page:"\(page)") { (FetchedVideos) in
                    self.getVideoArray(FetchedVideos)
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
        
        return cell
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
        if let videoList = videoList {
            let videoURL = URL(string: videoList[indexPath.row].videoUrl)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            present(playerViewController, animated: true) {
              player.play()
            }
        }
    }
    
}

extension VideosVC: HeaderActionsProtocol{
    
    func didSearchBarTapped() {
        let vc = VideoSearchViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func categoryTapped(_ category: String) {
        let vc = VideoCatgoryViewController()
        vc.query = category
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VideosVC: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    if let videoList = videoList {
        let cellWidth = (collectionView.frame.width - 44) / 2
        let imageRatio = CGFloat(videoList[indexPath.row].width) / CGFloat(videoList[indexPath.row].height)
        return CGFloat(cellWidth / imageRatio)
    }
    return CGFloat()
  }
}


