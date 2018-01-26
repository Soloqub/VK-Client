//
//  NewsListProvider.swift
//  VK Client
//
//  Created by Денис Львович on 21.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class NewsListProvider {

    var config:RequestConfig

    required init(config:RequestConfig) {

        self.config = config
    }

    convenience init(token: String) {

        let defaultParams: Parameters = [
            "access_token": token,
            "v": "5.69",
            "fields":"nickname,domain,photo_50"
        ]

        let defaultConf:RequestConfig = (
            baseUrl: URL(string: "https://api.vk.com")!,
            method: "GET",
            path: "/method/newsfeed.get",
            params: defaultParams)

        self.init(config: defaultConf)
    }

    func makeURLRequest() -> URLRequest? {

        let url:URL = config.baseUrl.appendingPathComponent(config.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = config.method
        var encodedRequest:URLRequest

        do {

            encodedRequest = try URLEncoding.default.encode(urlRequest, with: config.params).asURLRequest()
            return encodedRequest
        } catch {

            print("error")
            return nil
        }
    }
    
    func getNewsList() {

        guard
            let path = Bundle.main.path(forResource: "sample", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe),
            let myStructDictionary = try? JSONDecoder().decode([String: ResponseNewsVK].self, from: data),
            let items = myStructDictionary["response"]?.items
            else {
                assertionFailure()
                return
        }

        print(items.count)

//        items.forEach() { item in
//
//            guard let type = NewsType(rawValue: item.type) else {
//                assertionFailure()
//                return
//            }
//
//            let newItem = News()
//            newItem.type = type
//            newItem.date = Date(timeIntervalSince1970: item.date)
//            newItem.text = item.text
//            newItem.sourceType = item.sourceID > 0 ? .profile : .group
//            newItem.sourceID = item.sourceID > 0 ? item.sourceID : item.sourceID * -1
//            newItem.views = item.views?.count
//            newItem.likes = item.likes?.count
//            newItem.reposts = item.reposts?.count
//
//            item.attachments?.forEach() {
//                if let type = AttachmentType(rawValue: $0.type) {
//
//                    switch type {
//
//                    case .photo:
//                        var newAttach = PostAttachmentWithPhotos(urls: [])
//
//                        if let urlString = $0.photo?.smallSizePhotoURL,
//                            let url = URL(string: urlString) {
//                            newAttach.urls.append(.small(url))
//                        }
//
//                        if let urlString = $0.photo?.middleSizePhotoURL,
//                            let url = URL(string: urlString) {
//                            newAttach.urls.append(.middle(url))
//                        }
//
//                        if let urlString = $0.photo?.bigSizePhotoURL,
//                            let url = URL(string: urlString) {
//                            newAttach.urls.append(.big(url))
//                        }
//
//                        if newAttach.urls.count < 1 { assertionFailure() } else {
//                            newItem.attachments.append(newAttach)
//                        }
//
//                    case .link:
//                        guard
//                            let url = $0.link?.url,
//                            let title = $0.link?.title,
//                            let caption = $0.link?.caption,
//                            let description = $0.link?.description else {
//                                assertionFailure()
//                                return
//                        }
//
//                        var newLink = PostAttachmentWithLink(url: url,
//                                                             title: title,
//                                                             caption: caption,
//                                                             description: description,
//                                                             photo: [])
//
//                        if let urlString = $0.photo?.smallSizePhotoURL,
//                            let url = URL(string: urlString) {
//                            newLink.photo.append(.small(url))
//                        }
//
//                        if let urlString = $0.photo?.middleSizePhotoURL,
//                            let url = URL(string: urlString) {
//                            newLink.photo.append(.middle(url))
//                        }
//
//                        if let urlString = $0.photo?.bigSizePhotoURL,
//                            let url = URL(string: urlString) {
//                            newLink.photo.append(.big(url))
//                        }
//                    }
//                }
//            }
//
//            item.photos?.forEach() { item in
//                var photo = WallPhoto()
//                photo.text = item.text
//                photo.likes = item.likes?.count
//
//                if let urlString = item.smallSizePhotoURL,
//                    let url = URL(string: urlString) {
//                    photo.urls.append(.small(url))
//                }
//
//                if let urlString = item.middleSizePhotoURL,
//                    let url = URL(string: urlString) {
//                    photo.urls.append(.middle(url))
//                }
//
//                if let urlString = item.bigSizePhotoURL,
//                    let url = URL(string: urlString) {
//                    photo.urls.append(.big(url))
//                }
//            }
//        }
    }
}
