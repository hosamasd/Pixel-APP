//
//  MainVideosModel.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

struct MainVideosModel:Codable {
    let videos: [VideoModel]
       let perPage: Int
       let url: String
       let totalResults, page: Int

       enum CodingKeys: String, CodingKey {
           case videos
           case perPage = "per_page"
           case url
           case totalResults = "total_results"
           case page
       }
}

struct VideoModel:Codable {
  let height: Int
    let user: User
    let videoFiles: [VideoFile]
    let id: Int
    var fullRes: String?
    let width: Int
    let image: String
    let duration: Int
    let videoPictures: [VideoPicture]
    var tags: [String]?
    let url: String

    enum CodingKeys: String, CodingKey {
        case height, user
        case videoFiles = "video_files"
        case id
        case fullRes = "full_res"
        case width, image, duration
        case videoPictures = "video_pictures"
        case tags, url
    }
    
}


struct User: Codable {
    let id: Int
    let name: String
    let url: String
}

// MARK: - VideoFile
struct VideoFile: Codable {
    let link: String
    let id: Int
    let quality: Quality
    let fileType: FileType
    let width, height: Int?

    enum CodingKeys: String, CodingKey {
        case link, id, quality
        case fileType = "file_type"
        case width, height
    }
}

enum FileType: String, Codable {
    case videoMp4 = "video/mp4"
}

enum Quality: String, Codable {
    case hd = "hd"
    case hls = "hls"
    case sd = "sd"
}

// MARK: - VideoPicture
struct VideoPicture: Codable {
    let id: Int
    let picture: String
    let nr: Int
}

