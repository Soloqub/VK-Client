//
//  News.swift
//  VK Client
//
//  Created by Денис Львович on 21.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

class News {

    var date = Date()
    var sourceID: Int = 0
    var sourceType: SourceType = .profile
}

class Post: News {

    var text = ""
    var views = 0
    var likes = 0
    var reposts = 0
    var attachments: [Attachments]?
}

class PhotoWall: News {

    var photos = [Photo]()
}

protocol Attachments {
}

struct PostAttachmentWithPhotos: Attachments {

    var urls = [URLSize]()
}

struct PostAttachmentWithLink: Attachments {

    var url: String
    var title: String
    var caption: String?
    var description: String
    var photo: [URLSize]
}

struct Photo {

    var urls = [URLSize]()
    var text: String?
    var likes: Int?
}

enum URLSize {
    case big(URL)
    case middle(URL)
    case small(URL)

    static let values = [URLSize.big, URLSize.middle, URLSize.small]
}

enum NewsType: String {
    case post
    case wallPhoto = "wall_photo"
}

enum AttachmentType: String {
    case photo
    case link
}

enum SourceType {
    case profile
    case group
}
