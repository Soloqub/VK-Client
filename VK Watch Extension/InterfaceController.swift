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
        super.willActivate()

        if WCSession.isSupported() {

            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

        if activationState == .activated {

            let decoder = JSONDecoder()
            session.sendMessage(["request": "friends"], replyHandler: { [weak self] reply in
                if let json = reply["friends"] as? Data {
                    
                    do {
                        let items = try decoder.decode([WatchFriend].self, from: json)

                        items.forEach() { item in
                            self?.friendsList.append(Friend(id: item.id, name: item.name, image: nil))
                        }
                        self?.loadDataTable()
                        DispatchQueue.global(qos: .userInteractive).async {
                            self?.loadPictures(withSession: session)
                        }
                    }  catch {
                        assertionFailure(error.localizedDescription)
                        self?.showAlert()
                        return
                    }
                }
            }, errorHandler: { error in
                self.showAlert()
            })
        } else {
            assertionFailure("Session isn't activated")
        }
    }

    func loadDataTable() {

        self.table.setNumberOfRows(friendsList.count, withRowType: "friendCell")

        for index in 0..<friendsList.count {
            if let row = self.table.rowController(at: index) as? FriendRow {
                row.ava.setImage(friendsList[index].image)
                row.nameLabel.setText(friendsList[index].name)
            }
        }
    }
    
    func loadPictures(withSession session: WCSession) {
        for index in 0..<self.friendsList.count {
            session.sendMessage(["request": "avatar", "id": self.friendsList[index].id], replyHandler: { [weak self] reply in
                
                if let imageData = reply["avatar"] as? Data,
                    let image = imageData.toData,
                    let row = self?.table.rowController(at: index) as? FriendRow {
                    
                    self?.friendsList[index].image = image
                    row.ava.setImage(image)
                }
            }, errorHandler: { error in
                assertionFailure(error.localizedDescription)
            })
        }
    }
    
    func showAlert() {
        
        let action = WKAlertAction(title: "Error", style: WKAlertActionStyle.default) {
            print("OK")
        }
        presentAlert(withTitle: "Ошибка",
                     message: "Возникла ошибка синхронизации. Повторите позже.",
                     preferredStyle: WKAlertControllerStyle.alert,
                     actions:[action])
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    struct Friend {
        var id: Int
        var name: String
        var image: UIImage?
    }
}
