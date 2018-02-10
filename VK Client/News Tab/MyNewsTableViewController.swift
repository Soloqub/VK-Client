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
    var views = [[CellViews: UIView]]()

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

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithPhotos", for: indexPath) // as! PostWithPhotosCell

        guard let headerView = self.views[indexPath.row][.header],
            let header = headerView as? HeaderView,
            let mainView = self.views[indexPath.row][.main],
            let main = mainView as? MainContent
            else {
                assertionFailure()
                return cell
        }

        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })

        if let url = self.news[indexPath.row].source?.photo {
            self.setPhoto(forImageView: header.avatar, withURL: url)
        }

        cell.contentView.addSubview(header)

        switch self.news[indexPath.row] {

        case let post as PostWithPhotos:
            for (index, image) in post.photos.enumerated() {

                if index == 0 {
                    self.setPhoto(forImageView: main.mainImageView, withURL: image.url)
                } else {
                    self.setPhoto(forImageView: main.images[index - 1], withURL: image.url)
                }
            }
        default:
            break
        }

        cell.contentView.addSubview(main)

        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if self.views.count - 1 < indexPath.row {

            let header = HeaderView(frame: .zero)
            header.nameLabel.text = self.news[indexPath.row].source?.name
            header.dateLabel.text = self.news[indexPath.row].date.vkDateFormatter()
//            print("")
//            if self.news[indexPath.row] is Post { print("Post") } else { print("PhotoWall") }
//            print("PostID: ",(self.news[indexPath.row] as? Post)?.id as Any)
//            print("Date: ", self.news[indexPath.row].date.vkDateFormatter())
//            print("SourceType: ", self.news[indexPath.row].sourceType.rawValue)
//            print("SourceID: ", self.news[indexPath.row].sourceID)
            header.configure()
            
            let mainContent = MainContent(aboveView: header)

            if let post = self.news[indexPath.row] as? Post {
                mainContent.textLabel.text = post.text

                switch self.news[indexPath.row] {

                case let post as PostWithPhotos:
                    if post.photos.count > 0 {
                        mainContent.mainImageSize = CGSize(width: post.photos[0].width,
                                                           height: post.photos[0].height)
                    }
                    if post.photos.count > 1 {
                        let maxSize = post.photos.count - 1 < 3 ? post.photos.count - 1 : 3
                        for index in 1...maxSize {
                            mainContent.imagesSizes.append(CGSize(width: post.photos[index].width, height: post.photos[index].height))
                        }
                    }
                default:
                    break
                }

                mainContent.configure()
            }

            self.views.append([:])
            self.views[indexPath.row][.header] = header
            self.views[indexPath.row][.main] = mainContent

            return header.viewHeight + mainContent.viewHeight
        } else {
            return self.views[indexPath.row][.header]!.height + self.views[indexPath.row][.main]!.height
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count //== 0 ? 0 : 1
    }

    func setPhoto(forImageView imageView: UIImageView, withURL url: URL) {

        imageView.af_setImage(withURL: url,
                              placeholderImage: UIImage(named: "noimage"),
                              progressQueue: .global(qos: .userInteractive))
    }

    enum CellViews {
        case header, main
    }
}
