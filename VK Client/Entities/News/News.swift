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
//    var attachments: [Attachments]?
}

class PostWithSinglePhoto: Post {

    var photo: Photo

    init(photo: Photo) {
        self.photo = photo
    }
}

class PostWithPhotos: Post {

    var photos = [Photo]()
}

class PostWithLink: Post {

    var url = ""
    var title = ""
    var caption: String?
    var description = ""
    var photo: Photo?
}

struct Photo {
    var width: CGFloat
    var height: CGFloat
    var url: URL
}

class PhotoWall: News {

    var photos = [PhotoWallPhoto]()
}

//protocol Attachments {
//}

struct PostAttachmentWithPhotos {

    var urls = [URLSizes: URL]()
    var height: Int
    var width: Int
}

struct PostAttachmentWithLink {

    var url: String
    var title: String
    var caption: String?
    var description: String
    var photo: [URLSizes: URL]
}

struct PhotoWallPhoto {

    var urls = [URLSizes: URL]()
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

enum URLSizes {
    case big
    case middle
    case small
    case smallest
}

enum NewsType: String {
    case post
    case wallPhoto = "wall_photo"
}

enum AttachmentType: String {
    case photo
    case link
}

enum SourceType: String {
    case profile
    case group
}
