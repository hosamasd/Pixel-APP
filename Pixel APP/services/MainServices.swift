//
//  MainServices.swift
//  Pixel APP
//
//  Created by Hossam on 9/8/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit

class MainServices {
    
    
    static func registerationGetMethodGenerics<T:Codable>(urlString:String,completion:@escaping (T?,Error?)->Void)  {
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data!)
                // success
                completion(objects, err)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
    
    static func registerationGetMethodGenericsWithHeaders<T:Codable>(urlString:String,completion:@escaping (T?,Error?)->Void)  {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(Constants.API_KEY)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            guard let data = data else {return}

            do {
                // success
                let objects = try JSONDecoder().decode(T.self, from: data)

                completion(objects, err)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
    
    static func registerationPostMethodGeneric<T:Codable>(postString:String,url:URL,completion:@escaping (T?,Error?)->Void)  {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            if let error = err {
                completion(nil,error)
            }
            
           guard let data = data else {return}

            
            do {
               
                let objects = try JSONDecoder().decode(T.self, from: data)
                // success
                completion(objects,nil)
            } catch let error {
                completion(nil,error)
            }
        }.resume()
    }
}

extension String {

    var conslePrintString: String {

        guard let data = "\""
            .appending(
                replacingOccurrences(of: "\\u", with: "\\U")
                    .replacingOccurrences(of: "\"", with: "\\\"")
            )
            .appending("\"")
            .data(using: .utf8) else {

            return self
        }

        guard let propertyList = try? PropertyListSerialization.propertyList(from: data,
                                                                             options: [],
                                                                             format: nil) else {
            return self
        }

        guard let string = propertyList as? String else {
            return self
        }

        return string.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
