//
//  SearchVC.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit


class SearchVC:UIViewController, UITextFieldDelegate {
    
    var FetchedImages:MainPhotosModel?
    var imageList=[PhotoModel]()
    var page:Int = 1
    
    var bottomConstraint: NSLayoutConstraint?
    
    lazy var navView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainHeight(constant: 70)
        return view
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        textField.tintColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
        textField.layer.cornerRadius = 5
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 45))
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.font = UIFont(name: "Times", size: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        textField.delegate=self
        textField.constrainHeight(constant: 45)
        return textField
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 255/255, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        layout.scrollDirection = .vertical
        cv.setCollectionViewLayout(layout, animated: false)
        let customLayout = PinterestLayout()
        cv.collectionViewLayout = customLayout
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        return cv
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("cancel", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Times-Bold", size: 20)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cancelModal), for: .touchUpInside)
        btn.constrainHeight(constant: 45)
        return btn
    }()
    
    lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constrainHeight(constant: 0.5)
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView()
        aI.style = .medium
        aI.color = .darkGray
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
    }()
    
    lazy var loadingMessage:UILabel = {
        let message = UILabel()
        message.font = UIFont(name: "Times", size: 20)
        message.textColor = .darkGray
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        
        setupViews()
        setupNotifications()
        
        //bottomconstraints
        bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        ///Assigning Custom layout
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func setupViews()  {
        view.addSubViews(views: navView,collectionView)
        
        navView.addSubViews(views: searchTextField,seperatorView,cancelBtn)
        view.addSubview(collectionView)
        collectionView.addSubViews(views:activityIndicator,loadingMessage)
        
        navView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        seperatorView.anchor(top: nil, leading: navView.leadingAnchor, bottom: navView.bottomAnchor, trailing: navView.trailingAnchor)
        searchTextField.anchor(top: nil, leading: navView.leadingAnchor, bottom: nil, trailing: navView.trailingAnchor,padding: .init(top: 0, left: 17, bottom: 0, right: 10))
        cancelBtn.anchor(top: nil, leading: searchTextField.trailingAnchor, bottom: nil, trailing: navView.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 17))
        collectionView.anchor(top: navView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: navView.trailingAnchor)
        activityIndicator.anchor(top: collectionView.topAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 30, left: 0, bottom: 0, right: 0))
        loadingMessage.anchor(top: activityIndicator.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            
            searchTextField.centerYAnchor.constraint(equalTo: navView.centerYAnchor),
            cancelBtn.centerYAnchor.constraint(equalTo: navView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    fileprivate func getImagesAndCached() {
        FetchImageModel.fetchImages(url: "\(Constants.BASE_URL)/search", query: "new", perPage: "40", page: "\(page)") { (FetchedImages,err)  in
            guard let FetchedImages=FetchedImages else{return}
            self.FetchedImages = FetchedImages
            self.getImageArray(FetchedImages)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func getImageArray(_ data:MainPhotosModel){
        var images = [PhotoModel]()
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
    
    
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            FetchImageModel.fetchImages(url: "\(Constants.BASE_URL)/search", query: "new", perPage: "10", page: "1") { (FetchedImagess,err)  in
                guard let FetchedImages=FetchedImagess else {return}
                self.FetchedImages = FetchedImages
                self.imageList.removeAll()
                self.getImageArray(FetchedImages)
                DispatchQueue.main.async{
                    self.loadingMessage.text = (self.FetchedImages?.photos?.count == 0) ? "No result" : ""
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            }
            
            if self.searchTextField.text == ""{
                self.loadingMessage.text = ""
            }
        })
        
    }
    
    @objc func cancelModal(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
            
            UIView.animate(withDuration:0.1, delay: 0 , options: .curveEaseOut , animations: {
                self.view.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }
}

extension SearchVC:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count > 0 ?  imageList.count : 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.data = imageList[indexPath.row].photographerURL
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //pagination here
        let totalPosts = FetchedImages?.totalResults
        if indexPath.row == imageList.count - 1{
            if totalPosts! > imageList.count {
                self.page += 1
                
                getImagesAndCached()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                cell.imgView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.backView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                cell.imgView.transform = .identity
                cell.backView.transform = .identity
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImagePreviewVC()
        //            vc.imageId = imageList[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

extension SearchVC: PinterestLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        if imageList.count > 0 {
            let cellWidth = (collectionView.frame.width - 44) / 2
            let imageRatio = CGFloat(imageList[indexPath.row].width) / CGFloat(imageList[indexPath.row].height)
            return CGFloat(cellWidth / imageRatio)
            
        }
        return CGFloat()
    }
}

