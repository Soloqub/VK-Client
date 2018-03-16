//
//  TodayViewController.swift
//  VK 5 Friends Extension
//
//  Created by Денис Львович on 23.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    private var realm = RealmHelper<Friends>()
    @IBOutlet weak var nameOne: UILabel!
    @IBOutlet weak var nameTwo: UILabel!
    @IBOutlet weak var nameThree: UILabel!
    @IBOutlet weak var nameFour: UILabel!
    @IBOutlet weak var nameFive: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {

        self.realm.fetchAll(withType: Friends.self)

        if let friends = self.realm.objects {
            let names = [nameOne, nameTwo, nameThree, nameFour, nameFive]

            for index in 0...min(4, friends.count - 1) {
                names[index]?.text = friends[index].name
            }

            completionHandler(NCUpdateResult.newData)
        } else {
            completionHandler(NCUpdateResult.noData)
        }
    }
}
