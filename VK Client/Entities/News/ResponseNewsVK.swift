//
//  ResponseNewsVK.swift
//  VK Client
//
//  Created by Денис Львович on 28.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct ResponseNewsVK: Decodable {

    var items: [Item]
    var profiles: [ProfileVK]
    var groups: [GroupVK]

    struct Item: Decodable {

        var id: Int?
        var type: String
        var sourceID: Int
        var date: TimeInterval
        var text: String?
        var attachments: [Attach]?
        var photos: Photos?
        var views: Views?
        var likes: Like?
        var reposts: Repost?
        var isRepost: [CopyHistory]?

        enum CodingKeys : String, CodingKey {
            case id = "post_id"
            case type
            case date
            case text
            case attachments
            case photos
            case views
            case likes
            case reposts
            case sourceID = "source_id"
            case isRepost = "copy_history"
        }
    }

    struct Views: Decodable {
        var count: Int

        enum CodingKeys : String, CodingKey {
            case count
        }
    }

    struct Like: Decodable {
        var count: Int

        enum CodingKeys : String, CodingKey {
            case count
        }
    }

    struct Repost: Decodable {
        var count: Int

        enum CodingKeys : String, CodingKey {
            case count
        }
    }

    struct Attach: Decodable {
        var type: String
        var photo: AttachmentPhoto?
        var link: AttachmentLink?

        enum CodingKeys : String, CodingKey {
            case type
            case photo
            case link
        }
    }

    struct AttachmentPhoto: Decodable {
        var bigSizePhotoURL: String?
        var middleSizePhotoURL: String?
        var smallSizePhotoURL: String?
        var smallestSizePhotoURL: String?
        var width: Int
        var height: Int

        enum CodingKeys : String, CodingKey {
            case bigSizePhotoURL = "photo_1280"
            case middleSizePhotoURL = "photo_807"
            case smallSizePhotoURL = "photo_604"
            case smallestSizePhotoURL = "photo_130"
            case width
            case height
        }
    }

    struct AttachmentLink: Decodable {
        var url: String
        var title: String
        var caption: String?
        var description: String
        var photo: AttachmentPhoto?

        enum CodingKeys: String, CodingKey {
            case url
            case title
            case caption
            case description
            case photo
        }
    }

    struct Photos: Decodable {
        var items: [Photo]

        enum CodingKeys : String, CodingKey {
            case items
        }
    }

    struct Photo: Decodable {
        var bigSizePhotoURL: String?
        var middleSizePhotoURL: String?
        var smallSizePhotoURL: String?
        var smallestSizePhotoURL: String?
        var text: String?
        var likes: Like?

        enum CodingKeys : String, CodingKey {
            case text
            case likes
            case bigSizePhotoURL = "photo_1280"
            case middleSizePhotoURL = "photo_807"
            case smallSizePhotoURL = "photo_604"
            case smallestSizePhotoURL = "photo_130"
        }
    }

    struct CopyHistory: Decodable {
    }

    struct ProfileVK: Decodable, NewsSourceVK {

        var id: Int
        var firstName: String
        var lastName: String
        var photo: String

        enum CodingKeys : String, CodingKey {

            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case photo = "photo_50"
        }
    }

    struct GroupVK: Decodable, NewsSourceVK {

        var id: Int
        var name: String
        var photo: String

        enum CodingKeys : String, CodingKey {

            case id
            case name
            case photo = "photo_50"
        }
    }
}

protocol NewsSourceVK {

    var id: Int {set get}
    var photo: String {set get}
}
