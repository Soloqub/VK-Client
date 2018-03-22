//
//  UserPhotosListProvider.swift
//  VK Client
//
//  Created by Денис Львович on 10.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

//
//  FriendsListProvider.swift
//  VK Client
//
//  Created by Денис on 05.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import Foundation
import Alamofire

class UserPhotosListProvider {
    
    let router: Router

    init(withRouter router: Router) {
        self.router = router
    }

    func getUserPhotos(withOwnerID ownerId: Int, competition: @escaping (_ photosUrls: [String]) -> Void) {

        var config = router.getRequestConfig(byRequestType: .getUserPhotos)
        config.params.update(other: ["owner_id": ownerId])
        
        Alamofire.request(config.url, method: .get, parameters: config.params)
            .validate()
            .responseData(queue: .global(qos: .userInitiated)) { response in

                guard
                    let data = response.value,
                    let myStructDictionary = try? JSONDecoder().decode([String: ResponseFriendsPhotosVK].self, from: data),
                    let items = myStructDictionary["response"]?.items

                    else {
                        assertionFailure()
                        return
                }

                let photosUrls = items.flatMap{ $0.photo }

                DispatchQueue.main.async { competition(photosUrls) }
        }
    }
}


