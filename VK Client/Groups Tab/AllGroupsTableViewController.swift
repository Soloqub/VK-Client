//
//  AllGroupsTableViewController.swift
//  VK Client
//
//  Created by Денис Львович on 03.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase

class AllGroupsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var groupsList = [Groups]()
    
    var groupsListSaved = [Groups]() // Сюда сохраняем полный список групп при поиске
    var selectedGroup: Groups? // Здесь хранится выбранная ячейка
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Добавляем поиск
        self.searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = self.searchController.searchBar
        
        definesPresentationContext = true
        self.searchController.searchResultsUpdater  = self
        self.searchController.dimsBackgroundDuringPresentation = false

        self.configure()
    }

    private func configure() {

        let provider = UserGroupsListProvider(withRouter: Router.sharedInstance)
        provider.getAllGroupsList { [weak self] groups in

            self?.groupsList = groups
            self?.groupsListSaved = groups

            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VKGroup", for: indexPath)

        guard let url = URL(string: groupsList[indexPath.row].imagesURL) else {
            assertionFailure("Некорректный урл изображения!")
            return cell
        }

        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: CGSize(width: 50, height: 50),
            radius: 20.0
        )

        cell.textLabel?.text = groupsList[indexPath.row].name
        cell.imageView?.af_setImage(withURL: url,
                                    placeholderImage: UIImage(named: "noimage"),
                                    filter: filter,
                                    progressQueue: .global(qos: .userInteractive))

        return cell
    }
    
    // MARK: - Table View Control
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedGroup = self.groupsList[indexPath.row]
        self.joinGroup(withId: self.groupsList[indexPath.row].id)
    }

    private func joinGroup(withId id: Int) {

        let provider = UserGroupsListProvider(withRouter: Router.sharedInstance)
        provider.joinOrLeaveGroup(withId: id, isJoin: true) { [weak self] success in

            if success {
                // Проверка на активность searchController. Иначе он будет блокировать Unwind Segue
                if (self?.searchController.isActive)! {
                    self?.searchController.dismiss(animated: false, completion: {
                        self?.performSegue(withIdentifier: "addGroup", sender: self)
                        self?.addToFirebase(GroupWithId: id)
                    })
                } else {
                    self?.performSegue(withIdentifier: "addGroup", sender: self)
                    self?.addToFirebase(GroupWithId: id)
                }
            } else {
                self?.showMessage()
            }
        }
    }

    private func showMessage() {
        let alert  = UIAlertController(title: "Внимание!", message: "Не получилось подключиться к группе.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func addToFirebase(GroupWithId id: Int) {

        DispatchQueue.global(qos: .userInteractive).async {

            let defaults = UserDefaults.standard
            let userId = defaults.integer(forKey: "CurrentUserID")

            let dbLink = Database.database().reference()

            let group = GroupFB(id: id)
            dbLink.child("Users").child(userId.description).child("groups").child(id.description).setValue(group.toAnyObject)
        }
    }
    
    // MARK: - Search
    internal func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.isActive {
            
            restoreAfterSearch()
            return
        }
        
        let searchText = searchController.searchBar.text
        if let searchTextUrwraped = searchText {

            self.filterContentForSearchText(searchTextUrwraped)
            self.tableView.reloadData()
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        self.groupsList = self.groupsListSaved.filter({ (group: Groups) -> Bool in
            
            let nameMatch = group.name.range(of: searchText, options:
                NSString.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
    }
    
    private func restoreAfterSearch() {
        
        self.groupsList = self.groupsListSaved
        tableView.reloadData()
    }
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterContentForSearchText(searchText)
        self.tableView.reloadData()
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        restoreAfterSearch()
    }
}
