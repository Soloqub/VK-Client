//
//  FriendsListProvider.swift
//  VK Client
//
//  Created by Денис on 05.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class FriendsListProvider {
    
    var config:RequestConfig
    
    required init(config:RequestConfig) {
        
        self.config = config
    }
    
    convenience init(token: String) {
        
        let defaultParams: Parameters = [
            "access_token": token,
            "v": "5.69",
            "fields":"nickname,domain,photo_50"
        ]
        
        let defaultConf:RequestConfig = (
            baseUrl: URL(string: "https://api.vk.com")!,
            method: "GET",
            path: "/method/friends.get",
            params: defaultParams)
        
        self.init(config: defaultConf)
    }
    
    func makeURLRequest() -> URLRequest? {
        
        let url:URL = config.baseUrl.appendingPathComponent(config.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = config.method
        var encodedRequest:URLRequest
        
        do {
            
            encodedRequest = try URLEncoding.default.encode(urlRequest, with: config.params).asURLRequest()
            return encodedRequest
        } catch {
            
            print("error")
            return nil
        }
    }
}

