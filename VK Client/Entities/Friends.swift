//
//  Friends.swift
//  VK Client
//
//  Created by Денис Львович on 09.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import RealmSwift

class Friends: BaseEntity {}

struct ResponseFriendsVK: Decodable {
    
    var count: Int
    var items: [Item]

    struct Item: Decodable {
        
        var id:Int
        var firstName:String
        var lastName :String
        var mainPhotoURL:String
        
        enum CodingKeys : String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case mainPhotoURL  = "photo_50"
        }
    }
}

