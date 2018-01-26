//
//  MyNewsTableViewController.swift
//  VK Client
//
//  Created by Денис Львович on 15.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class MyNewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Пробуем получить список групп
        let token = KeychainWrapper.standard.string(forKey: "Token")!

        let provider = NewsListProvider(token: token)
        provider.getNewsList()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
