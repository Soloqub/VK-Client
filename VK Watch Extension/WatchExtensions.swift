//
//  WatchExtensions.swift
//  VK Watch Extension
//
//  Created by Денис on 12.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

extension Data {
    var toData: UIImage? {
        return UIImage(data: self)
    }
}
