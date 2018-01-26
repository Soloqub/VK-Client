//
//  UserGroupsListProvider.swift
//  VK Client
//
//  Created by Денис Львович on 12.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class UserGroupsListProvider {
    
    var config:RequestConfig
    
    required init(config:RequestConfig) {
        
        self.config = config
    }
    
    convenience init(token: String) {
        
        let defaultParams: Parameters = [
            "access_token": token,
            "v": "5.69",
            "extended": 1
        ]
        
        let defaultConf:RequestConfig = (
            baseUrl: URL(string: "https://api.vk.com")!,
            method: "GET",
            path: "/method/groups.get",
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

