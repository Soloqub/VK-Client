//
//  MyGroupsTableViewController.swift
//  VK Client
//
//  Created by Денис Львович on 30.11.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class MyGroupsTableViewController: UITableViewController {
    
    private var token = ""
    private var realm = RealmHelper<Groups>()
    internal var images: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cachedUserListLoad()
        self.realm.printPath()
        self.realm.realmNotificationCenter(forTableView: self.tableView)
        
        // Пробуем получить список групп
        self.token = KeychainWrapper.standard.string(forKey: "Token")!
        
        let provider = UserGroupsListProvider(token: token)
        self.getUsersList(with: provider)
    }
    
    
    private func cachedUserListLoad() {
        
        // Загружаем массив из базы
        self.realm.fetchAll(withType: Groups.self)
        
        guard let groups = self.realm.objects else { return }
        
        print("repeatElement")
        // Заполняем массив images
        self.images = Array(repeatElement(nil, count: groups.count))
        
        // Закачиваем фото
        groups.enumerated().forEach { index, group in
            
            // Добавляем к названиям групп слово " cached", чтобы показать что значение закэшировано
            let groupCached = Groups(value: group)
            groupCached.name = group.name + " cached"
            realm.update(withObjects: [groupCached])
            
            if let url = URL(string: group.imagesURL) {
                
                url.getPhoto() { image in
                    self.images[index] = image
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    private func getUsersList(with provider: UserGroupsListProvider) {

        Alamofire.request(provider.makeURLRequest()!).responseData(queue: .global(qos: .userInitiated)) { response in
            
            guard
                let data = response.value,
                let myStructDictionary = try? JSONDecoder().decode([String: ResponseGroupsVK].self, from: data),
                let items = myStructDictionary["response"]?.items,
                let myGroups = self.realm.objects
                
                else {
                    assertionFailure()
                    return
            }
            
            DispatchQueue.main.async {
                
                // Сравниваем полученное и кэш, убираем устаревшие элементы
                myGroups.enumerated().forEach { index, cacheItem in
                    
                    if !items.contains(where: { item in
                        item.id == cacheItem.id })
                    {
                        self.realm.delete(objects: [cacheItem])
                        self.images.remove(at: index)
                    }
                }
                
                // Создаём сущности
                items.enumerated().forEach { index, object in
                    
                    // Вытаскиваем объект с нужным ID
                    var objectIndex = myGroups.index(where: { $0.id == object.id })
                    var needReloadImage = true
                    
                    // Проверяем, изменился ли URL
                    if let objectIndex = objectIndex {
                        if myGroups[objectIndex].imagesURL == object.mainPhotoURL && self.images[objectIndex] != nil {
                            needReloadImage = false
                        }
                    } else {
                        self.images.append(nil)
                    }
                    
                    //Настраиваем Realm сущность Groups
                    let group = Groups()
                    guard let url = URL(string: object.mainPhotoURL) else {
                        
                        assertionFailure()
                        return
                    }
                    group.name = object.name
                    group.id = object.id
                    group.imagesURL = object.mainPhotoURL
                    
                    // Сохраняем в базу объект
                    self.realm.update(withObjects: [group])
                    
                    if objectIndex == nil {
                        objectIndex = myGroups.count - 1
                    }
                    
                    // Асинхронно грузим картинку, если необходимо
                    if needReloadImage {
                        if let objectIndex = objectIndex {
                            url.getPhoto() { image in
                                self.images[objectIndex] = image
                                self.tableView.reloadRows(at: [IndexPath(row: objectIndex, section: 0)], with: .automatic)
                            }
                        }
                    }
                }
            }
        }
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
        if let objects = self.realm.objects {
            if self.images.count < objects.count {
                for _ in 1...objects.count - self.images.count{
                    self.images.append(nil)
                    if let url = URL(string: objects[self.images.count - 1].imagesURL) {
                        url.getPhoto() {image in
                            self.images[self.images.count - 1] = image
                            self.tableView.reloadRows(at: [IndexPath(row: self.images.count - 1, section: 0)], with: .automatic)
                        }
                    }
                }
            }
        }
        
        return self.realm.objects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroup", for: indexPath)
        guard let myGroups = self.realm.objects else { return cell }
        
        cell.textLabel?.text = myGroups[indexPath.row].name

        if self.images.count > 0 {
            
            cell.imageView?.image = self.images[indexPath.row] ?? UIImage(named: "noimage")
        } else {
            
            cell.imageView?.image = UIImage(named: "noimage")
        }
        
        // Configure the cell...

        return cell
    }
 

    // MARK: - Table View Control
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let objects = self.realm.objects {
            if self.images.count > objects.count {
                
                self.images.remove(at: indexPath.row)
            }
        }
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

    
    // MARK: - Navigation
    
    @IBAction func  addGroup(segue: UIStoryboardSegue)  {}

}
