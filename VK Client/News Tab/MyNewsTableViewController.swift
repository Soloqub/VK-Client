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

    var news = [News]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let token = KeychainWrapper.standard.string(forKey: "Token")!

        // Пробуем получить список новостей
        let provider = NewsListProvider(token: token)
        provider.getNewsList() { [weak self] news in

            self?.news = news
            self?.tableView.reloadData()
            print(self?.news.count as Any)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simplest", for: indexPath)
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
}
