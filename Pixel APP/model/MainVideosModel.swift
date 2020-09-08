//
//  MainVideosModel.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

struct MainVideosModel:Codable {
    var totalResults,page,perPage:Int?
          var nextPage: String?
          var videos: [VideoModel]?

          enum CodingKeys: String, CodingKey {
              case page
              case totalResults = "total_results"
              case nextPage = "next_page"
              case videos
              case perPage = "per_page"
          }
}

struct VideoModel:Codable {
    let height: Int
          let photographer: String
          let url: String
          let photographerID: Int
          var src: Src?
          let id: Int
          let liked: Bool
          let width: Int
          let photographerURL: String

          enum CodingKeys: String, CodingKey {
              case height, photographer, url
              case photographerID = "photographer_id"
              case src, id, liked, width
              case photographerURL = "photographer_url"
          }
    
}
