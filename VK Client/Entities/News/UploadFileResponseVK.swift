//
//  UploadFileResponseVK.swift
//  VK Client
//
//  Created by Денис Львович on 17.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct UploadFileResponseVK: Decodable {

    var server: Int
    var photo: String
    var hash: String
}
