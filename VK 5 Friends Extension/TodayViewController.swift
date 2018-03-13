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

    @IBOutlet weak var tableView: UITableView!
    private var realm = RealmHelper<Friends>()
    private var friendsNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 210)

        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {

        self.realm.fetchAll(withType: Friends.self)

        if let friends = self.realm.objects {
            for index in 0...min(4, friends.count - 1) {
                friendsNames.append(friends[index].name)
            }
            tableView.reloadData()

            completionHandler(NCUpdateResult.newData)
        } else {
            completionHandler(NCUpdateResult.noData)
        }
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 5.0 * 44.0)
        }else if activeDisplayMode == .compact{
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110)
        }
    }
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "todayExtensionCell", for: indexPath)
        cell.textLabel?.text = self.friendsNames[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsNames.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
