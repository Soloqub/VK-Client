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
    var source: NewsSource?
    var sourceType: SourceType = .profile
}

class Post: News {

    var id = 0
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

struct Profile: NewsSource {

    var id: Int
    var name: String
    var photo: URL
}

struct GroupVK: NewsSource {

    var id: Int
    var name: String
    var photo: URL
}

protocol NewsSource {

    var id: Int {set get}
    var name: String {set get}
    var photo: URL {set get}
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
