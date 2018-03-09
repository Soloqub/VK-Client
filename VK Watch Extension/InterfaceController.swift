//
//  TableInterfaceController.swift
//  VK Watch Extension
//
//  Created by Денис Львович on 01.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import WatchKit
import WatchConnectivity

class TableInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var table: WKInterfaceTable!

    var session: WCSession?
    var friendsList = [Friend]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        if WCSession.isSupported() {

            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

        if activationState == .activated {
            session.sendMessage(["request": "friends"], replyHandler: { reply in

                if let names = reply["friends"] as? [String] {

                    names.forEach() { item in
                        self.friendsList.append(Friend(name: item, image: nil))
                    }
                    self.reloadTable()
                }

            }, errorHandler: { error in
                print(error.localizedDescription)
            })
        } else {
            print("Session isn't activated")
        }
    }

    func reloadTable() {

        self.table.setNumberOfRows(friendsList.count, withRowType: "friendCell")

        for index in 0..<friendsList.count {

            if let row = self.table.rowController(at: index) as? FriendRow {

                //                row.ava =
                row.nameLabel.setText(friendsList[index].name)
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    struct Friend {

        var name: String
        var image: UIImage?
    }

}
