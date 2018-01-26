//
//  AllGroupsTableViewController.swift
//  VK Client
//
//  Created by Денис Львович on 03.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var groupsList = [
        vkGroup(name: "Бог фотошопа", avatar: UIImage(named: "bog_f"), amountOfMembers: "467 673 подписчиков"),
        vkGroup(name: "Хитрости жизни | GIF", avatar: UIImage(named: "hitrosti"), amountOfMembers: "1 197 191 подписчиков"),
        vkGroup(name: "Арт Бот", avatar: UIImage(named: "art_bot"), amountOfMembers: "2 004 603 подписчиков"),
        vkGroup(name: "Сделай сам | GIF", avatar: UIImage(named: "sdelay_sam"), amountOfMembers: "115 750 подписчиков"),
        vkGroup(name: "Индивидуалист", avatar: UIImage(named: "individualist"), amountOfMembers: "315 780 подписчиков"),
        vkGroup(name: "Экспериментатор | GIF", avatar: UIImage(named: "experimentator"), amountOfMembers: "337 182 подписчиков"),
    ]
    
    var groupsListSaved = [vkGroup]() // Сюда сохраняем полный список групп при поиске
    var selectedGroup:vkGroup? // Здесь хранится выбранная ячейка
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Добавляем поиск
        self.searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = self.searchController.searchBar
        
        definesPresentationContext = true
        
        self.searchController.searchResultsUpdater  = self
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.groupsListSaved = self.groupsList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VKGroup", for: indexPath)

        cell.textLabel?.text = groupsList[indexPath.row].name
        cell.detailTextLabel?.text = groupsList[indexPath.row].amountOfMembers
        cell.imageView?.image = groupsList[indexPath.row].avatar
        
        // Configure the cell...

        return cell
    }
    
    // MARK: - Table View Control
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedGroup = self.groupsList[indexPath.row]
        
        // Проверка на активность searchController. Иначе он будет блокировать Unwind Segue
        if self.searchController.isActive {

            self.searchController.dismiss(animated: false, completion: {
                
                self.performSegue(withIdentifier: "AddingGroup", sender: self)
            })
            
        } else {
            
            performSegue(withIdentifier: "AddingGroup", sender: self)
        }
    }
    
    // MARK: - Search
    func updateSearchResults(for searchController: UISearchController) {
        
        if !searchController.isActive {
            
            restoreAfterSearch()
            return
        }
        
        let searchText = searchController.searchBar.text
        
        guard let searchTextUrwraped = searchText else { return }
        
        self.filterContentForSearchText(searchTextUrwraped)
        
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        self.groupsList = self.groupsListSaved.filter({ (group:vkGroup) -> Bool in
            
            let nameMatch = group.name.range(of: searchText, options:
                NSString.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
    }
    
    func restoreAfterSearch() {
        
        self.groupsList = self.groupsListSaved
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterContentForSearchText(searchText)
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        restoreAfterSearch()
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
