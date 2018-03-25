//
//  FriendsListProvider.swift
//  VK Client
//
//  Created by Денис on 05.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class FriendsListProvider {
    
    let router: Router

    init(withRouter router: Router) {
        self.router = router
    }
    
    func getFriendsList(competition: @escaping (_ friends: [Friends]) -> Void) {

        let config = router.getRequestConfig(byRequestType: .getFriendsList)
        Alamofire.request(config.url, method: .get, parameters: config.params)
            .validate()
            .responseData(queue: .global(qos: .userInitiated)) { response in

                guard
                    let data = response.value,
                    let myStructDictionary = try? JSONDecoder().decode([String: ResponseFriendsVK].self, from: data),
                    let items = myStructDictionary["response"]?.items

                    else {
                        assertionFailure()
                        return
                }

                var friends = [Friends]()

                items.forEach { object in

                    //Настраиваем Realm сущность Friends
                    let friend = Friends()
                    friend.name = object.firstName + " " + object.lastName
                    friend.id = object.id
                    friend.imagesURL = object.mainPhotoURL

                    friends.append(friend)
                }

                DispatchQueue.main.async { competition(friends) }
        }
    }
}

