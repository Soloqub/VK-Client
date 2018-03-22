//
//  UserGroupsListProvider.swift
//  VK Client
//
//  Created by Денис Львович on 12.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class UserGroupsListProvider {
    
    let router: Router

    init(withRouter router: Router) {
        self.router = router
    }

    func getUserGroups(realm: RealmHelper<Groups>, competition: @escaping (_ friends: [Groups]) -> Void) {

        let config = router.getRequestConfig(byRequestType: .getUserGroups)
        Alamofire.request(config.url, method: .get, parameters: config.params)
            .validate()
            .responseData(queue: .global(qos: .userInitiated)) { response in

                guard
                    let data = response.value,
                    let myStructDictionary = try? JSONDecoder().decode([String: ResponseGroupsVK].self, from: data),
                    let items = myStructDictionary["response"]?.items

                    else {
                        assertionFailure()
                        return
                }

                var groups = [Groups]()

                items.forEach { object in

                    //Настраиваем Realm сущность Friends
                    let group = Groups()
                    group.name = object.name
                    group.id = object.id
                    group.imagesURL = object.mainPhotoURL

                    groups.append(group)
                }

                DispatchQueue.main.async { competition(groups) }
        }
    }
}

