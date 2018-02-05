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
    var views = [[CellViews:UIView]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()

        let token = KeychainWrapper.standard.string(forKey: "Token")!
        // Пробуем получить список новостей
        let provider = NewsListProvider(token: token)
        provider.getNewsList() { [weak self] news in

            self?.news = news
            self?.tableView.reloadData()
            print(self?.news.count as Any)
        }
    }

    func configureTableView() {

//        self.tableView.estimatedRowHeight = 100
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(PostWithPhotosCell.self, forCellReuseIdentifier: "PostWithPhotos")

//        self.tableView.translatesAutoresizingMaskIntoConstraints = false
//        self.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithPhotos", for: indexPath) as! PostWithPhotosCell

        if let headerView = self.views[indexPath.row][.header], let header = headerView as? HeaderView {
            cell.header = header
            cell.addSubview(header)
//            cell.setNeedsLayout()
        } else {
            assertionFailure()
        }

        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.views.count - 1 < indexPath.row {

            print("heightForRowAt: ", indexPath.row)
            let header = HeaderView(frame: .zero)
            header.nameLabel.text = self.news[indexPath.row].source?.name
            header.dateLabel.text = self.news[indexPath.row].date.description
            header.configure()

            self.views.append([:])
            self.views[indexPath.row][.header] = header
            print("header.bounds.height: ", header.frame.height)

            return header.bounds.height
        } else {

            return self.views[indexPath.row][.header]!.height
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }

    enum CellViews {
        case header
    }
}
