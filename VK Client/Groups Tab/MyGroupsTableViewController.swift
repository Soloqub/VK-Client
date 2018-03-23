//
//  MyGroupsTableViewController.swift
//  VK Client
//
//  Created by Денис Львович on 30.11.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import AlamofireImage

class MyGroupsTableViewController: UITableViewController {
    
    private var realm = RealmHelper<Groups>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.realm.realmNotificationCenter(forTableView: self.tableView)
        self.configure()
    }

    private func configure() {

        self.realm.fetchAll(withType: Groups.self)
        self.tableView.reloadData()

        let provider = UserGroupsListProvider(withRouter: Router.sharedInstance)
        provider.getUserGroups(realm: realm) { [weak self] groups in

            self?.realm.deleteAll(withType: Groups.self)
            self?.realm.update(withObjects: groups)

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath)
        guard let myGroups = self.realm.objects,
            let url = URL(string: myGroups[indexPath.row].imagesURL)
            else { return cell }

        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: CGSize(width: 50, height: 50),
            radius: 20.0
        )
        
        cell.textLabel?.text = myGroups[indexPath.row].name
        cell.imageView?.af_setImage(withURL: url,
                                    placeholderImage: UIImage(named: "noimage"),
                                    filter: filter,
                                    progressQueue: .global(qos: .userInteractive))
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
//            self.myGroups.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
