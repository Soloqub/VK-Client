//
//  NewsListProvider.swift
//  VK Client
//
//  Created by Денис Львович on 21.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import PromiseKit

class NewsListProvider {

    func getDefaultConfig(forAction type: ActionType) -> RequestConfig {

        let token = KeychainWrapper.standard.string(forKey: "Token")!

        switch type {
        case .messagePost:
            let params: Parameters = [
                "access_token": token,
                "v": "5.70",
                "friends_only": "1"
            ]

            return ( baseUrl: URL(string: "https://api.vk.com")!,
                method: "POST",
                path: "/method/wall.post",
                params: params)

        case .getNews:
            let params: Parameters = [
                "access_token": token,
                "v": "5.70"
            ]

            return ( baseUrl: URL(string: "https://api.vk.com")!,
                method: "GET",
                path: "/method/newsfeed.get",
                params: params)

        case .getPhotoServer:
            let params: Parameters = [
                "access_token": token,
                "v": "5.70",
                "album_id": 1
            ]

            return ( baseUrl: URL(string: "https://api.vk.com")!,
                     method: "GET",
                     path: "/method/photos.getUploadServer",
                     params: params)
        }
    }

    func makeURLRequest(forConfig config: RequestConfig) -> URLRequest? {

        let url:URL = config.baseUrl.appendingPathComponent(config.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = config.method
        var encodedRequest:URLRequest

        do {
            encodedRequest = try URLEncoding.default.encode(urlRequest, with: config.params).asURLRequest()
            print(encodedRequest)
            return encodedRequest
        } catch {

            print("error")
            return nil
        }
    }

    func uploadPhoto() {

        firstly {
            self.getPhotosServer()
        }
        }

    private func getPhotosServer() -> Promise<URL> {

        let config = self.getDefaultConfig(forAction: .getPhotoServer)

        Alamofire.request(self.makeURLRequest(forConfig: config)!).responseData(queue: .global(qos: .userInitiated)) { response in

            guard
                let data = response.value,
                let response = try? JSONDecoder().decode(PostResponseVK.self, from: data)
                else {
                    assertionFailure()
                    return
            }

            if response.response != nil  {
                print("Posting OK")
                print(response)
                DispatchQueue.main.async { completion(true, nil) }
            } else if let error = response.error {
                print(error.message)
                DispatchQueue.main.async { completion(false, error) }
            } else {
                assertionFailure("Этого не может быть!")
                DispatchQueue.main.async { completion(false, nil) }
            }
        }
    }
    
    func getNewsList(completion: @escaping (_ news: [News]) -> Void) {

        let config = self.getDefaultConfig(forAction: .getNews)

        Alamofire.request(self.makeURLRequest(forConfig: config)!).responseData(queue: .global(qos: .userInitiated)) { response in

            guard
                let data = response.value,
                let myStructDictionary = try? JSONDecoder().decode([String: ResponseNewsVK].self, from: data),
                let items = myStructDictionary["response"]?.items
                else {
                    assertionFailure()
                    return
            }

            var newsArray = [News]()
            var profilesArray = [Profile]()
            var groupsArray = [GroupVK]()

            if let profiles = myStructDictionary["response"]?.profiles {
                profilesArray = self.parseSources(fromArray: profiles) as! [Profile]
            }

            if let groups = myStructDictionary["response"]?.groups {
                groupsArray = self.parseSources(fromArray: groups) as! [GroupVK]
            }

            print("Найдено сущностей: ", items.count)

            items.enumerated().forEach { index, item in
                if let type = NewsType(rawValue: item.type) {

                    switch type {
                    case .post:
                        if item.isRepost != nil {
                            print("Запись является репостом с id: ", item.id as Any, " пропускаем")
                            return
                        }
                        if item.attachments != nil || item.text != "" {
                            if let pieceOfNews = self.createPost(withItem: item) {

                                pieceOfNews.source = pieceOfNews.sourceType == .profile ?
                                    profilesArray.first(where: {$0.id == pieceOfNews.sourceID}) :
                                    groupsArray.first(where: {$0.id == pieceOfNews.sourceID})

                                newsArray.append(pieceOfNews)
                            } else { return }

                        } else {
                            print("Пустой пост без приложений и текста с id: ", item.id as Any)
                            return
                        }
                    case .wallPhoto:
                        break
//                        let pieceOfNews = self.createPhotoWall(withItem: item)
//
//                        if pieceOfNews.photos.count > 0 {
//                            pieceOfNews.source = pieceOfNews.sourceType == .profile ?
//                                profilesArray.first(where: {$0.id == pieceOfNews.sourceID}) :
//                                groupsArray.first(where: {$0.id == pieceOfNews.sourceID})
//
//                            newsArray.append(pieceOfNews)
//
//                        } else {
//                            assertionFailure("Некорректная структура PhotoWall")
//                            return
//                        }
                    }

                } else {
                    print(item.type)
                }
            }

            print("Новостей: ", newsArray.count)
            DispatchQueue.main.async { completion(newsArray) }
        }
    }
    
    func post(withParams params: [String: Any], completion: @escaping (_ success: Bool, _ error: PostResponseVK.Error?) -> Void) {

        var config = self.getDefaultConfig(forAction: .messagePost)
        config.params.update(other: params)

        Alamofire.request(self.makeURLRequest(forConfig: config)!).responseData(queue: .global(qos: .userInitiated)) { response in
            guard
                let data = response.value,
                let response = try? JSONDecoder().decode(PostResponseVK.self, from: data)
                else {
                    assertionFailure()
                    return
            }

            if response.response != nil  {
                print("Posting OK")
                print(response)
                DispatchQueue.main.async { completion(true, nil) }
            } else if let error = response.error {
                print(error.message)
                DispatchQueue.main.async { completion(false, error) }
            } else {
                assertionFailure("Этого не может быть!")
                DispatchQueue.main.async { completion(false, nil) }
            }
        }
    }

    private func createPost(withItem item: ResponseNewsVK.Item) -> Post? {

        guard
            let id = item.id,
            let text = item.text,
            let likes = item.likes?.count,
            let reposts = item.reposts?.count else {
                assertionFailure()
                return nil
        }
        let views = item.views?.count ?? 0

        var photosArray = [PostAttachmentWithPhotos]()
        var linksArray = [PostAttachmentWithLink]()

        if let attachments = item.attachments {
            for attach in attachments {

                let urlStrings: [URLSizes: String?] = [.small: attach.photo?.smallSizePhotoURL,
                                  .middle: attach.photo?.middleSizePhotoURL,
                                  .big: attach.photo?.bigSizePhotoURL,
                                  .smallest: attach.photo?.smallestSizePhotoURL]
                let photoUrls = self.parsePhotos(withStrings: urlStrings)

                if let type = AttachmentType(rawValue: attach.type) {

                    switch type {
                    case .photo:
                        guard let photoItem = attach.photo else {
                            assertionFailure("Некорректный аттач типа Photo")
                            return nil
                        }
                        let newAttach = PostAttachmentWithPhotos(urls: photoUrls, height: photoItem.height, width: photoItem.width)

                        if newAttach.urls.count < 1 { assertionFailure() } else {
                            photosArray.append(newAttach)
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
                        linksArray.append(newLink)
                    }
                } else {
                    print("Нераспарсиваемый тип: ", attach.type)
                    print("Пропускаем элемент")
                    return nil
                }
            }
        }

        let newItem: Post

        if linksArray.count < 1 && photosArray.count >= 0 {

            var photos = [Photo]()

            if photosArray.count > 0 {
                if let photo = self.photoFrom(attachmentPhoto: photosArray[0], asFirstPhoto: true) {
                    photos.append(photo)
                } else {
                    return nil
                }
            }

            if photosArray.count > 1 {
                for index in 1...photosArray.count - 1 {
                    if let photo = self.photoFrom(attachmentPhoto: photosArray[index], asFirstPhoto: false) {
                        photos.append(photo)
                    }
                }
            }
            newItem = PostWithPhotos(photos: photos)

        } else {
            print("Пост содержит неподдерживаемый тип вложений, пропускаем")
            return nil
        }

        newItem.id = id
        newItem.date = Date(timeIntervalSince1970: item.date)
        newItem.text = text
        newItem.sourceType = item.sourceID > 0 ? .profile : .group
        newItem.sourceID = item.sourceID > 0 ? item.sourceID : item.sourceID * -1
        newItem.views = views
        newItem.likes = likes
        newItem.reposts = reposts

        return newItem
    }

//    private func createPhotoWall(withItem item: ResponseNewsVK.Item) -> PhotoWall {
//
//        let photoWall = PhotoWall()
//
//        item.photos?.items.forEach { item in
//            var photo = PhotoWallPhoto()
//            photo.text = item.text
//            photo.likes = item.likes?.count
//
//            let urlStrings: [URLSizes: String?] = [.small: item.smallSizePhotoURL,
//                              .middle: item.middleSizePhotoURL,
//                              .big: item.bigSizePhotoURL,
//                              .smallest: item.smallestSizePhotoURL]
//            photo.urls = self.parsePhotos(withStrings: urlStrings)
//
//            if photo.urls.count > 0 {
//                photoWall.photos.append(photo)
//            } else {
//                assertionFailure("Некорректное фото")
//                return
//            }
//        }
//
//        photoWall.date = Date(timeIntervalSince1970: item.date)
//        photoWall.sourceID = item.sourceID > 0 ? item.sourceID : item.sourceID * -1
//        photoWall.sourceType = item.sourceID > 0 ? .profile : .group
//
//        return photoWall
//    }

    private func parsePhotos(withStrings urlStrings: [URLSizes: String?]) -> [URLSizes: URL] {

        var urls = [URLSizes: URL]()

        if let urlStringOptional = urlStrings[.smallest],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls[.smallest] = url
        }

        if let urlStringOptional = urlStrings[.small],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls[.small] = url
        }

        if let urlStringOptional = urlStrings[.middle],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls[.middle] = url
        }

        if let urlStringOptional = urlStrings[.big],
            let urlString = urlStringOptional,
            let url = URL(string: urlString) {

            urls[.big] = url
        }

        return urls
    }

    private func parseSources(fromArray sources: [NewsSourceVK]) -> [NewsSource] {

        if sources is [ResponseNewsVK.ProfileVK] {

            guard let profiles = sources as? [ResponseNewsVK.ProfileVK] else {
                assertionFailure("Этого не может быть")
                return []
            }

            var profilesArray = [Profile]()

            for profile in profiles {
                guard let photoUrl = URL(string: profile.photo) else {
                    assertionFailure("С урлом непорядок")
                    continue
                }
                
                let newProfile = Profile(id: profile.id, name: profile.firstName + " " + profile.lastName, photo: photoUrl)
                profilesArray.append(newProfile)
            }

            return profilesArray
        } else {

            guard let groups = sources as? [ResponseNewsVK.GroupVK] else {
                assertionFailure("Этого не может быть")
                return []
            }

            var groupsArray = [GroupVK]()

            for group in groups {
                guard let photoUrl = URL(string: group.photo) else {
                    assertionFailure("С урлом непорядок")
                    continue
                }

                let newGroup = GroupVK(id: group.id, name: group.name, photo: photoUrl)
                groupsArray.append(newGroup)
            }

            return groupsArray
        }
    }

    private func photoFrom(attachmentPhoto attach: PostAttachmentWithPhotos, asFirstPhoto firstPhoto: Bool) -> Photo? {

        let photoUrl: URL
        if firstPhoto {

            if let url = attach.urls[.big] { photoUrl = url } else
            if let url = attach.urls[.middle] { photoUrl = url } else
                if let url = attach.urls[.small] { photoUrl = url } else {
                    assertionFailure()
                    return nil
            }
        } else {
            if let url = attach.urls[.small] { photoUrl = url } else if
            let url = attach.urls[.smallest] { photoUrl = url } else if
            let url = attach.urls[.middle] { photoUrl = url } else {
                        assertionFailure()
                        return nil
            }
        }

        return Photo(width: CGFloat(attach.width), height: CGFloat(attach.height), url: photoUrl)
    }
    

    enum ActionType {
        case messagePost, getNews, getPhotoServer
    }
}

/* Тестовая проверка json
 guard
 let path = Bundle.main.path(forResource: "sample", ofType: "json"),
 let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: Data.ReadingOptions.mappedIfSafe),
 let myStructDictionary = try? JSONDecoder().decode([String: ResponseNewsVK].self, from: data),
 let items = myStructDictionary["response"]?.items
 else {
 assertionFailure()
 return
 }
 */
