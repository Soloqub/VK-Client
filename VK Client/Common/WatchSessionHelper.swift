//
//  WatchSessionHelper.swift
//  VK Client
//
//  Created by Денис Львович on 02.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import WatchConnectivity

@objc
class WatchSessionHelper: NSObject, WCSessionDelegate {

    static let shared = WatchSessionHelper()
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    private override init() {
        super.init()
    }

    func startSession() {
        self.session?.delegate = self
        self.session?.activate()
    }

    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

    }

    private var validSession: WCSession? {

        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {

        let realm = RealmHelper<Friends>()

        if let key = message["request"] as? String {
            switch key {

            case "friends":
                realm.fetchAll(withType: Friends.self)
                guard let friends = realm.objects else {
                    assertionFailure("Не получилось вытащить объекты из базы")
                    return
                }

                let friendsStruct: [WatchFriend] = friends.map { WatchFriend(id: $0.id, name: $0.name) }
                let encoder = JSONEncoder()
                let data = try! encoder.encode(friendsStruct)

                replyHandler(["friends": data])

            case "avatar":
                if let id = message["id"] as? Int,
                    let friend = realm.fetchObject(withType: Friends.self, andID: id),
                    let url = URL(string: friend.imagesURL) {

                    url.getPhoto { image in
                        if let data = image?.jpegToData {
                            replyHandler(["avatar": data])
                        } else { assertionFailure("Не JPEG") }
                    }
                } else { assertionFailure("Не получилось вытащить URL аватара для объекта из базы") }
            default:
                return
            }
        }
    }

//    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
//
//        if let session = validSession {
//
//            do {
//                try session.updateApplicationContext(applicationContext)
//            } catch let error {
//                throw error
//            }
//        }
//    }
}
