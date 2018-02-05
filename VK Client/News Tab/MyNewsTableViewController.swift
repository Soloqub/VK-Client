//
//  MyNewsTableViewController.swift
//  VK Client
//
//  Created by Денис Львович on 15.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import AlamofireImage

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

        self.tableView.register(PostWithPhotosCell.self, forCellReuseIdentifier: "PostWithPhotos")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithPhotos", for: indexPath) as! PostWithPhotosCell

        if let headerView = self.views[indexPath.row][.header], let header = headerView as? HeaderView {
            cell.header = header
            cell.addSubview(header)

            if let url = self.news[indexPath.row].source?.photo {
                self.setPhoto(forImageView: cell.header.avatar, withURL: url)
            }

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

//            print("heightForRowAt: ", indexPath.row)
            let header = HeaderView(frame: .zero)
            header.nameLabel.text = self.news[indexPath.row].source?.name
            header.dateLabel.text = self.news[indexPath.row].date.vkDateFormatter()
//            print("")
//            print("PostID: ",(self.news[indexPath.row] as? Post)?.id as Any)
//            print("Date: ", self.news[indexPath.row].date.vkDateFormatter())
//            print("SourceType: ", self.news[indexPath.row].sourceType.hashValue)
//            print("SourceID: ", self.news[indexPath.row].sourceID)
            header.configure()

            self.views.append([:])
            self.views[indexPath.row][.header] = header
//            print("header.bounds.height: ", header.frame.height)

            return header.bounds.height
        } else {
            return self.views[indexPath.row][.header]!.height
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }

    func setPhoto(forImageView imageView: UIImageView, withURL url: URL) {

        imageView.af_setImage(withURL: url,
                              placeholderImage: UIImage(named: "noimage"),
                              progressQueue: .global(qos: .userInteractive))
    }

    enum CellViews {
        case header
    }
}
