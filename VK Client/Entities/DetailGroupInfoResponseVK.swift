//
//  DetailGroupInfoResponseVK.swift
//  VK Client
//
//  Created by Денис Львович on 24.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct DetailGroupInfoResponseVK: Decodable {

    var id: Int
    var name: String
    var isMember: Int
    var isClosed: Int
    var mainPhotoURL: String
    var membersCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isMember  = "is_member"
        case isClosed  = "is_closed"
        case mainPhotoURL  = "photo_50"
        case membersCount = "members_count"
    }
}
