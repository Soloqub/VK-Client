//
//  FriendsTableViewController.swift
//  VK Client
//
//  Created by Денис on 20.10.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import AlamofireImage

class FriendsTableViewController: UITableViewController {
    
    private var realm = RealmHelper<Friends>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.realm.realmNotificationCenter(forTableView: self.tableView)
        self.configure()
    }

    private func configure() {

        self.realm.fetchAll(withType: Friends.self)
        self.tableView.reloadData()

        let provider = FriendsListProvider(withRouter: Router.sharedInstance)
        provider.getFriendsList(realm: realm) { [weak self] friends in 

            self?.realm.deleteAll(withType: Friends.self)
            self?.realm.update(withObjects: friends)

            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.realm.objects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let friends = self.realm.objects,
            let url = URL(string: friends[indexPath.row].imagesURL)
            else { return cell }
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: CGSize(width: 50, height: 50),
            radius: 20.0
        )

        cell.textLabel?.text = friends[indexPath.row].name
        cell.imageView?.af_setImage(withURL: url,
                                            placeholderImage: UIImage(named: "noimage"),
                                            filter: filter,
                                            progressQueue: .global(qos: .userInteractive))

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "To Gallery", sender: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let friends = self.realm.objects else { return }
        
        var destinationController:FriendsGalleryViewController
        
        // Обрабатываем дурацкую ситуацию с destinationViewController. Если система воспринимает как destination UINavigationController, if срабатывает. В противном случае работает штатно с целевым контроллером.
        if let nav = segue.destination as? UINavigationController {
            destinationController = nav.topViewController as! FriendsGalleryViewController
        } else {
            destinationController = segue.destination as! FriendsGalleryViewController
        }
        
        destinationController.friendsName = friends[(sender as! IndexPath).row].name
        destinationController.ownerId = friends[(sender as! IndexPath).row].id
    }
}
