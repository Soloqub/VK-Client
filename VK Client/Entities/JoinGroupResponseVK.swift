//
//  JoinGroupResponseVK.swift
//  VK Client
//
//  Created by Денис Львович on 24.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct JoinGroupResponseVK: Decodable {

    var successResponse: Int?
    var error: Error?

    enum CodingKeys : String, CodingKey {
        case successResponse = "response"
        case error
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
