//
//  UserInfoProvider.swift
//  VK Client
//
//  Created by Денис Львович on 25.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Alamofire

class UserInfoProvider {

    let router: Router

    init(withRouter router: Router) {
        self.router = router
    }

    func getSelfInfo(competition: @escaping (_ id: Int) -> Void) {

        let config = router.getRequestConfig(byRequestType: .getUserInfo)
        Alamofire.request(config.url, method: .get, parameters: config.params)
            .validate()
            .responseData(queue: .global(qos: .userInitiated)) { response in

                guard
                    let data = response.value,
                    let myStructDictionary = try? JSONDecoder().decode([String: [UserInfoResponseVK]].self, from: data),
                    let items = myStructDictionary["response"]

                    else {
                        assertionFailure()
                        return
                }

                let object = items[0]
                let id = object.id

                competition(id)
        }
    }
}

struct UserInfoResponseVK: Decodable {
    var id: Int
}
