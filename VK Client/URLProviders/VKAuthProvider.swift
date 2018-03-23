//
//  VKAuthProvider.swift
//  VK Client
//
//  Created by Денис on 05.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class VKAuthProvider {
    
    func makeURLRequest() -> URLRequest? {
        let config = Router.sharedInstance.getRequestConfig(byRequestType: .auth)
        
        do {
            let urlRequest = try URLRequest(url: config.url, method: .get)
            let requestWithParams = try URLEncoding.default.encode(urlRequest, with: config.params).asURLRequest()
            return requestWithParams
        } catch {
            assertionFailure(error.localizedDescription)
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

