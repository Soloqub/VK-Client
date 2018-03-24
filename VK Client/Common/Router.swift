//
//  Router.swift
//  VK Client
//
//  Created by Денис Львович on 20.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class Router {

    static let sharedInstance = Router()
    private let actualAPIVersion = "5.73"
    private let token = KeychainWrapper.standard.string(forKey: "Token")!
    
    private init() { }

    func getRequestConfig(byRequestType requestType: RequestType) -> RequestConfig {

        switch requestType {

        case.auth:
            return self.authorization()

        case .messagePost:
            return self.messagePost()

        case .getNews:
            return self.getNews()

        case .getPhotoServer:
            return self.getPhotoServer()

        case .saveWallPhoto:
            return self.saveWallPhoto()

        case .getUserGroups:
            return self.getUserGroups()

        case .getFriendsList:
            return self.getFriendsList()

        case .getUserPhotos:
            return self.getUserPhotos()

        case .getAllGroupsList:
            return self.getAllGroupsList()

        case .joinGroup:
            return self.joinGroup()

        case .leaveGroup:
            return self.leaveGroup()

        case .getGroupInfo:
            return self.getGroupInfo()
        }
    }

    private func authorization() -> RequestConfig {

        let url = URL(string: "https://oauth.vk.com/authorize")!
        let params: Parameters = [
            "client_id": "6411475",
            "display": "mobile",
            "redirect_uri": "https://oauth.vk.com/blank.html",
            "scope": "270342",
            "response_type": "token",
            "v": actualAPIVersion
        ]
        return RequestConfig(url: url, params: params)
    }

    struct RequestConfig {
        var url: URL
        var params: Parameters
    }

    enum RequestType {
        case auth, messagePost, getNews, getPhotoServer, saveWallPhoto,
        getUserGroups, getAllGroupsList, joinGroup, leaveGroup, getGroupInfo,
        getFriendsList, getUserPhotos
    }
}


extension FriendsRouter {

    private func getFriendsList() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/friends.get")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion,
            "fields":"nickname,domain,photo_50"
        ]
        return RequestConfig(url: url, params: params)
    }

    private func getUserPhotos() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/photos.getAll")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion,
            "fields":"nickname,domain,photo_50"
        ]
        return RequestConfig(url: url, params: params)
    }
}


extension GroupsRouter {

    private func getUserGroups() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/groups.get")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion,
            "extended": 1,
            "fields": "members_count"
        ]
        return RequestConfig(url: url, params: params)
    }

    private func getAllGroupsList() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/groups.getCatalog")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion
        ]
        return RequestConfig(url: url, params: params)
    }

    private func getGroupInfo() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/groups.getById")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion,
            "fields": "members_count"
        ]
        return RequestConfig(url: url, params: params)
    }

    private func joinGroup() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/groups.join")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion
        ]
        return RequestConfig(url: url, params: params)
    }

    private func leaveGroup() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/groups.leave")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion
        ]
        return RequestConfig(url: url, params: params)
    }
}


extension NewsRouter {

    private func getNews() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/newsfeed.get")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion
        ]
        return RequestConfig(url: url, params: params)
    }
}


extension WallPostRouter {

    private func messagePost() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/wall.post")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion,
            "friends_only": "1"
        ]
        return RequestConfig(url: url, params: params)
    }

    private func getPhotoServer() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/photos.getWallUploadServer")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion,
            "album_id": 1
        ]
        return RequestConfig(url: url, params: params)
    }

    private func saveWallPhoto() -> RequestConfig {

        let url = URL(string: "https://api.vk.com/method/photos.saveWallPhoto")!
        let params: Parameters = [
            "access_token": self.token,
            "v": actualAPIVersion
        ]
        return RequestConfig(url: url, params: params)
    }
}

fileprivate typealias GroupsRouter = Router
fileprivate typealias FriendsRouter = Router
fileprivate typealias NewsRouter = Router
fileprivate typealias WallPostRouter = Router
