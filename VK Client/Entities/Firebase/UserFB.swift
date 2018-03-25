//
//  UserFB.swift
//  VK Client
//
//  Created by Денис Львович on 25.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct UserFB: Codable {
    let id: Int
    var groups: [GroupFB]

    var toAnyObject: Any {
        return [
            "id": id,
            "groups": groups.map { $0.toAnyObject }
        ]
    }
}

struct GroupFB: Codable {
    let id: Int

    var toAnyObject: Any {
        return [
            "id": id
        ]
    }
}
