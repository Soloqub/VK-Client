//
//  Groups.swift
//  VK Client
//
//  Created by Денис Львович on 12.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit

class Groups: BaseEntity {
    @objc dynamic var membersCount = 0
}

struct ResponseGroupsVK: Decodable {
    
    var count: Int
    var items: [Item]
    
    struct Item: Decodable {
        
        var id: Int
        var name: String
        var isMember: Int
        var isClosed: Int
        var mainPhotoURL: String
        var membersCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case isMember  = "is_member"
            case isClosed  = "is_closed"
            case mainPhotoURL  = "photo_50"
            case membersCount = "members_count"
        }
    }
}
