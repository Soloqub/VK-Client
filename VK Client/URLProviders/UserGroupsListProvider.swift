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

    func getUserGroups(competition: @escaping (_ groups: [Groups]) -> Void) {

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
                    group.membersCount = object.membersCount ?? 0

                    groups.append(group)
                }

                DispatchQueue.main.async { competition(groups) }
        }
    }

    func getAllGroupsList(competition: @escaping (_ groups: [Groups]) -> Void) {

        let config = router.getRequestConfig(byRequestType: .getAllGroupsList)
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

                for object in items where (object.isMember == 0 && object.isClosed == 0) {

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

    func joinGroup(withId id: Int, competition: @escaping (_ success: Bool) -> Void) {

        var config = router.getRequestConfig(byRequestType: .joinGroup)
        config.params.update(other: ["group_id": id])
        let mainQueue = DispatchQueue.main

        Alamofire.request(config.url, method: .post, parameters: config.params)
            .validate()
            .responseData(queue: .global(qos: .userInitiated)) { response in

                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            mainQueue.async{ competition(false) }
                            return
                        }

                        let responseObject = try JSONDecoder().decode(JoinGroupResponseVK.self, from: data)
                        if responseObject.successResponse != nil {
                            mainQueue.async{ competition(true) }
                        } else if responseObject.error != nil {
                            mainQueue.async{ competition(false) }
                        } else {
                            mainQueue.async{ competition(false) }
                        }
                    } catch {
                        assertionFailure()
                        mainQueue.async{ competition(false) }
                    }

                case .failure:
                    competition(false)
                }
        }
    }
}

