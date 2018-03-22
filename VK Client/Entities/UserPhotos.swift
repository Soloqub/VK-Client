//
//  UserPhotos.swift
//  VK Client
//
//  Created by Денис Львович on 10.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit

class UserPhotos {
    
    var images = [UIImage]()
    
}

struct ResponseFriendsPhotosVK: Decodable {
    
    var count: Int
    var items: [Item]
    
    struct Item: Decodable {
        
        var photo:String?
        
        enum CodingKeys : String, CodingKey {
            case photo = "photo_807"
        }
    }
}
