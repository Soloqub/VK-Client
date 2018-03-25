//
//  UserFB.swift
//  VK Client
//
//  Created by Денис Львович on 25.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct UserFB {
    let id: Int

    var toAnyObject: Any {
        return [
            "id": id
        ]
    }
}

struct GroupFB {
    let id: Int

    var toAnyObject: Any {
        return [
            "id": id
        ]
    }
}
