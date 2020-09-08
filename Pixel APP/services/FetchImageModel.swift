//
//  FetchImageModel.swift
//  Pixel APP
//
//  Created by Hossam on 9/7/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Photos {
    var id:Int!
    var width:Int!
    var height:Int!
    var thumbnail:String!
}

class FetchImageModel:NSObject {
    
    var totalResults:Int!
    var photoData:[Photos]!
    
    
    
    static func fetchImages(url:String, query:String, perPage:String, page:String, completion: @escaping (MainPhotosModel?,Error??) -> ()){
        
        let urls = "\(url)/?query=\(query)&per_page=\(perPage)&page=\(page)"
        
        MainServices.registerationGetMethodGenericsWithHeaders(urlString: urls, completion: completion)
        
    }
    
    static func fetchImagesUsingID(url:String, id:String, completion: @escaping (PhotoModel?,Error?) -> ()){
        
        let urls = "\(url)/\(id)"
        
        
        MainServices.registerationGetMethodGenericsWithHeaders(urlString: urls, completion: completion)
    }
    
}
