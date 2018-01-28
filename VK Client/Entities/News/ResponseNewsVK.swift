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

    struct Item: Decodable {

        var id: Int
        var type: String
        var sourceID: Int
        var date: TimeInterval
        var text: String?
        var attachments: [Attach]?
        var photos: Photos?
        var views: Views?
        var likes: Like?
        var reposts: Repost?

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

        enum CodingKeys : String, CodingKey {
            case bigSizePhotoURL = "photo_1280"
            case middleSizePhotoURL = "photo_807"
            case smallSizePhotoURL = "photo_604"
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
        var text: String?
        var likes: Like?

        enum CodingKeys : String, CodingKey {
            case text
            case likes
            case bigSizePhotoURL = "photo_1280"
            case middleSizePhotoURL = "photo_807"
            case smallSizePhotoURL = "photo_604"
        }
    }
}
