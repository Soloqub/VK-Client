//
//  BaseEntity.swift
//  VK Client
//
//  Created by Денис Львович on 16.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import RealmSwift

class BaseEntity: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var imagesURL = ""

    override static func primaryKey() -> String {
        return "id"
    }
}
