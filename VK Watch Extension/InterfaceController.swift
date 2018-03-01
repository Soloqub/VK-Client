//
//  TableInterfaceController.swift
//  VK Watch Extension
//
//  Created by Денис Львович on 01.03.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import WatchKit
import Foundation


class TableInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        self.table.setNumberOfRows(5, withRowType: "friendCell")

        for index in 0..<5 {

            if let row = self.table.rowController(at: index) as? FriendRow {

//                row.ava =
                row.nameLabel.setText("")
            }
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
