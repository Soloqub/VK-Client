//
//  WatchFriend.swift
//  VK Client
//
//  Created by Денис Львович on 13.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct WatchFriend: Codable {

    var id = 0
    var name = ""

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
