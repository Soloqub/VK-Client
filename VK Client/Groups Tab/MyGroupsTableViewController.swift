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
        provider.getUserGroups { [weak self] groups in

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
        cell.detailTextLabel?.text = "Участников: \(myGroups[indexPath.row].membersCount)"
        cell.imageView?.af_setImage(withURL: url,
                                    placeholderImage: UIImage(named: "noimage"),
                                    filter: filter,
                                    progressQueue: .global(qos: .userInteractive))
        
        return cell
    }

    private func showMessage() {
        let alert  = UIAlertController(title: "Внимание!", message: "Не получилось подключиться к группе.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func addingGroup(_ sender: UIStoryboardSegue) {

        if let senderVC = sender.source as? AllGroupsTableViewController,
            let group = senderVC.selectedGroup {

            self.realm.update(withObjects: [group])
            self.tableView.reloadData()
            self.updateInfo(group: group)
        }
    }

    private func updateInfo(group: Groups) {

        let provider = UserGroupsListProvider(withRouter: Router.sharedInstance)
        provider.getGroupInfo(withId: group.id) { [weak self] group in

            self?.realm.update(withObjects: [group])

            if let rowsCount = self?.tableView.numberOfRows(inSection: 0) {
                let indexPathOfLastRow = IndexPath(row: rowsCount - 1, section: 0)
                self?.tableView.reloadRows(at: [indexPathOfLastRow], with: .automatic)
            }
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let groups = self.realm.objects else {
                return
            }
            
            let provider = UserGroupsListProvider(withRouter: Router.sharedInstance)
            provider.joinOrLeaveGroup(withId: groups[indexPath.row].id, isJoin: false) { [weak self] success in
                
                if success {
                    self?.realm.delete(objects: [groups[indexPath.row]])
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    self?.showMessage()
                }
            }
        }
    }
}
