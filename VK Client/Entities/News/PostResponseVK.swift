//
//  PostResponseVK.swift
//  VK Client
//
//  Created by Денис Львович on 19.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct PostResponseVK: Decodable {

    var response: Post?
    var error: Error?

    struct Post: Decodable {
        var id: Int

        enum CodingKeys : String, CodingKey {
            case id = "post_id"
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
