//
//  Groups.swift
//  VK Client
//
//  Created by Денис Львович on 12.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit

class Groups: BaseEntity {
    
}

struct ResponseGroupsVK: Decodable {
    
    var count: Int
    var items: [Item]
    
    struct Item: Decodable {
        
        var id:Int
        var name:String
        var mainPhotoURL:String
        
        enum CodingKeys : String, CodingKey {
            case id
            case name
            case mainPhotoURL  = "photo_50"
        }
    }
}
