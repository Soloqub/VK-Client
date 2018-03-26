//
//  LeaveAccount.swift
//  VK Client
//
//  Created by Денис Львович on 26.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import SwiftKeychainWrapper
import WebKit

class LeaveAccount {

    func logOut() {
        clearCookies()
        clearDefaults()
        clearDataBase()
    }

    private func clearCookies() {

        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName.contains("vk.com") {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: { })
                }
            }
        }
    }

    private func clearDefaults() {
        KeychainWrapper.standard.removeObject(forKey: "Token")
        UserDefaults.standard.removeObject(forKey: "CurrentUserID")
    }

    private func clearDataBase() {

        let realmFriends = RealmHelper<Friends>()
        realmFriends.deleteAll(withType: Friends.self)
        let realmGroups = RealmHelper<Groups>()
        realmGroups.deleteAll(withType: Groups.self)
        let realmNews = RealmHelper<MessageNews>()
        realmNews.deleteAll(withType: MessageNews.self)
    }
}
