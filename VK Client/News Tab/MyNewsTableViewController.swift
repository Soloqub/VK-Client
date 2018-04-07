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

    private var provider = NewsListProvider(withRouter: Router.sharedInstance)
    private var realm = RealmHelper<MessageNews>()
    var news = [News]()
    var views = [[CellViews: UIView]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTableView()
        self.request()
    }
    
    private func request() {
        
        // Пробуем получить список новостей
        provider.getNewsList() { [weak self] news in
            
            self?.news = news
            self?.tableView.reloadData()

            if news.count > 0 {
                guard
                    let post = self?.news[0] as? Post,
                    let authorName = post.source?.name else {
                        return
                }

                self?.realm.deleteAll(withType: MessageNews.self)

                let item = MessageNews()
                item.name = authorName
                item.text = post.text
                item.postId = post.id

                if let photoPost = post as? PostWithPhotos, photoPost.photos.count > 0 {
                    item.image = photoPost.photos[0].url.absoluteString
                }

                self?.realm.update(withObjects: [item])
            }
        }
    }

    private func configureTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostWithPhotos")
        self.tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostWithPhotos", for: indexPath) // as! PostWithPhotosCell

        guard let headerView = self.views[indexPath.row][.header],
            let header = headerView as? HeaderView,
            let mainView = self.views[indexPath.row][.main],
            let main = mainView as? MainContent,
            let footerView = self.views[indexPath.row][.footer],
            let footer = footerView as? FooterView
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
                    if index <= main.images.count {
                        self.setPhoto(forImageView: main.images[index - 1], withURL: image.url)
                    }
                }
            }
        default:
            break
        }

        cell.contentView.addSubview(main)
        cell.contentView.addSubview(footer)

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
            header.configure()
            
            let mainContent = MainContent(frame: .zero)
            let footer = FooterView(frame: .zero)

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

                    footer.viewsLabel.text = post.views.description
                    footer.likesLabel.text = post.likes.description
                    footer.repostsLabel.text = post.reposts.description
                default:
                    break
                }
            }

            mainContent.setOrigin(forAboveView: header)
            mainContent.configure()

            footer.setOrigin(forAboveView: mainContent)
            footer.configure()

            self.views.append([:])
            self.views[indexPath.row][.header] = header
            self.views[indexPath.row][.main] = mainContent
            self.views[indexPath.row][.footer] = footer

            return header.viewHeight + mainContent.viewHeight + footer.viewHeight + 5
        } else {
            return self.views[indexPath.row][.header]!.height + self.views[indexPath.row][.main]!.height + self.views[indexPath.row][.footer]!.height + 5
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
    
    @IBAction func unwindFromPost(_ sender: UIStoryboardSegue) {

        self.news.removeAll()
        self.views.removeAll()
        self.request()
    }

    @IBAction func exit(_ sender: Any) {
        let exitObject = LeaveAccount()
        exitObject.logOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }

    enum CellViews {
        case header, main, footer
    }
}
