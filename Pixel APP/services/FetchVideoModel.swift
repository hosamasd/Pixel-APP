//
//  FetchVideoModel.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class FetchVideoModel {
    
    
    static func fetchVideos(url:String, query:String, perPage:String, page:String, completion: @escaping (MainPhotosModel?,Error?) ->Void){
        
        let urls = "\(url)/?query=\(query)&per_page=\(perPage)&page=\(page)"
        
        MainServices.registerationGetMethodGenericsWithHeaders(urlString: urls, completion: completion)

       
    }
}
