//
//  VKAuthProvider.swift
//  VK Client
//
//  Created by Денис on 05.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestConfig = (baseUrl: URL, method: String, path: String, params:Parameters)

class VKAuthProvider {
    
    var config:RequestConfig
    
    required init(config:RequestConfig) {
        
        self.config = config
    }
    
    convenience init() {
        
        let defaultParams: Parameters = [
            "client_id": "6285802",
            "display": "mobile",
            "redirect_uri": "https://oauth.vk.com/blank.html",
            "scope": "270342",
            "response_type": "token",
            "v": "5.69"
        ]
        
        let defaultConf:RequestConfig = (
            baseUrl: URL(string: "https://oauth.vk.com")!,
            method: "GET",
            path: "/authorize",
            params: defaultParams)
        
        self.init(config: defaultConf)
    }
    
    func makeURLRequest() -> URLRequest? {
        
        let url:URL = config.baseUrl.appendingPathComponent(config.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = config.method
        
        do {
            
            return try URLEncoding.default.encode(urlRequest, with: config.params).asURLRequest()
        } catch {
            
            print("error")
            return nil
        }
    }
    
    class func parseURLFragment(parameters: String)  -> [String: String] {
        
        let parameters = parameters
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        return parameters
    }
}

