//
//  MessageNews.swift
//  VK Client
//
//  Created by Денис Львович on 25.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import RealmSwift

class MessageNews: Object {

    @objc dynamic var text = ""
    @objc dynamic var name = ""
    @objc dynamic var image: String?
    @objc dynamic var postId  = 0

    override static func primaryKey() -> String {
        return "postId"
    }
}
