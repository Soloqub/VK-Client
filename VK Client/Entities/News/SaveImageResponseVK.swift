//
//  SaveImageResponseVK.swift
//  VK Client
//
//  Created by Денис Львович on 18.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct SaveImageResponseVK: Decodable {

    var successResponse: Success?
    var error: Error?

    enum CodingKeys : String, CodingKey {
        case successResponse = "response"
        case error
    }

    struct Success: Decodable {
        var mediaID: Int
        var ownerID: Int
        var accessKey: String

        enum CodingKeys : String, CodingKey {
            case mediaID = "id"
            case ownerID = "owner_id"
            case accessKey = "access_key"
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
