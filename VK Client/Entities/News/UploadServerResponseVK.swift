//
//  UploadServerResponseVK.swift
//  VK Client
//
//  Created by Денис Львович on 15.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct UploadServerResponseVK: Decodable {

    var successResponse: Success?
    var error: Error?
    
    enum CodingKeys : String, CodingKey {
        case successResponse = "response"
        case error
    }

    struct Success: Decodable {
        var url: String

        enum CodingKeys : String, CodingKey {
            case url = "upload_url"
        }
    }

    struct Error: Decodable {
        var code: Int
        var message: String

        enum CodingKeys : String, CodingKey {
            case code = "error_code"
            case message = "error_msg"
        }
    }
}
