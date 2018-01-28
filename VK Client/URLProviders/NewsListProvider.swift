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

        var newsArray = [News]()

        print("Найдено сущностей: ", items.count)

        items.enumerated().forEach { index, item in
            
            if let type = NewsType(rawValue: item.type) {

                switch type {
                case .post:
                    if item.attachments != nil {

                        if let pieceOfNews = self.createPost(withItem: item) {
                            newsArray.append(pieceOfNews)
                        }

                    } else {
                        print("Пропускаем репост без аттачментов с id: ", item.id)
                        return
                    }
                case .wallPhoto:
                    let pieceOfNews = self.createPhotoWall(withItem: item)

                    if pieceOfNews.photos.count > 0 {
                        newsArray.append(pieceOfNews)
                    } else {
                        assertionFailure("Некорректная структура PhotoWall")
                        return
                    }
                }

            } else {
                print(item.type)
            }
        }
    }

    private func createPost(withItem item: ResponseNewsVK.Item) -> Post? {

        guard
            let text = item.text,
            let views = item.views?.count,
            let likes = item.likes?.count,
            let reposts = item.reposts?.count,
            let attachments = item.attachments else {

                assertionFailure()
                return nil
        }

        var attachmentsArray = [Attachments]()

        for attach in attachments {

            let urlStrings = ["Small": attach.photo?.smallSizePhotoURL,
                              "Middle": attach.photo?.middleSizePhotoURL,
                              "Big": attach.photo?.bigSizePhotoURL]
            let photoUrls = self.parsePhotos(withStrings: urlStrings)

            if let type = AttachmentType(rawValue: attach.type) {

                switch type {
                case .photo:
                    let newAttach = PostAttachmentWithPhotos(urls: photoUrls)

                    if newAttach.urls.count < 1 { assertionFailure() } else {
                        attachmentsArray.append(newAttach)
                    }

                case .link:
                    guard
                        let url = attach.link?.url,
                        let title = attach.link?.title,
                        let description = attach.link?.description else {
                            assertionFailure("Некорректный аттач типа Link")
                            return nil
                    }

                    let newLink = PostAttachmentWithLink(url: url,
                                                         title: title,
                                                         caption: attach.link?.caption,
                                                         description: description,
                                                         photo: photoUrls)
                    attachmentsArray.append(newLink)
                }
            } else {
                print("Нераспарсиваемый тип: ", attach.type)
                print("Пропускаем элемент")
                return nil
            }
        }

        let newItem = Post()
        newItem.date = Date(timeIntervalSince1970: item.date)
        newItem.text = text
        newItem.sourceType = item.sourceID > 0 ? .profile : .group
        newItem.sourceID = item.sourceID > 0 ? item.sourceID : item.sourceID * -1
        newItem.views = views
        newItem.likes = likes
        newItem.reposts = reposts
        newItem.attachments = attachmentsArray

        return newItem
    }

    private func createPhotoWall(withItem item: ResponseNewsVK.Item) -> PhotoWall {

        let photoWall = PhotoWall()

        item.photos?.items.forEach { item in
            var photo = Photo()
            photo.text = item.text
            photo.likes = item.likes?.count

            let urlStrings = ["Small": item.smallSizePhotoURL,
                              "Middle": item.middleSizePhotoURL,
                              "Big": item.bigSizePhotoURL]
            photo.urls = self.parsePhotos(withStrings: urlStrings)

            if photo.urls.count > 0 {
                photoWall.photos.append(photo)
            } else {
                assertionFailure("Некорректное фото")
                return
            }
        }

        return photoWall
    }

    private func parsePhotos(withStrings urlStrings: [String: String?]) -> [URLSize] {

        var urls = [URLSize]()

        if let urlStringOptional = urlStrings["Small"],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls.append(.small(url))
        }

        if let urlStringOptional = urlStrings["Middle"],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls.append(.middle(url))
        }

        if let urlStringOptional = urlStrings["Big"],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls.append(.big(url))
        }

        return urls
    }
}
