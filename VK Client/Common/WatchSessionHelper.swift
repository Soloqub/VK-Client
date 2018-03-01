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

    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {

        if let session = validSession {

            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
}
