//
//  FriendsTableViewController.swift
//  VK Client
//
//  Created by Денис on 20.10.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class FriendsTableViewController: UITableViewController {
    
    private var token = ""
    private var realm = RealmHelper<Friends>()
    internal var images: [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cachedUserListLoad()
        self.realm.printPath()
        self.realm.realmNotificationCenter(forTableView: self.tableView)
        
        // Пробуем получить список друзей
        self.token = KeychainWrapper.standard.string(forKey: "Token")!
        
        let provider = FriendsListProvider(token: token)
        self.getUsersList(with: provider)
    }
    
    private func cachedUserListLoad() {
        
        // Загружаем массив из базы
        self.realm.fetchAll(withType: Friends.self)
        
        guard let friends = self.realm.objects else { return }
        
        print("repeatElement")
        // Заполняем массив images
        self.images = Array(repeatElement(nil, count: friends.count))
        
        // Закачиваем фото
        friends.enumerated().forEach { index, friend in
            
            // Добавляем к именам друзей слово " cached", чтобы показать что значение закэшировано
            let friendCached = Friends(value: friend)
            friendCached.name = friend.name + " cached"
            realm.update(withObjects: [friendCached])
            
            if let url = URL(string: friend.imagesURL) {
                url.getPhoto() { image in
                    self.images[index] = image
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }
    
    private func getUsersList(with provider: FriendsListProvider) {

        Alamofire.request(provider.makeURLRequest()!).responseData(queue: .global(qos: .userInitiated)) { response in
            
            guard
                let data = response.value,
                let myStructDictionary = try? JSONDecoder().decode([String: ResponseFriendsVK].self, from: data),
                let items = myStructDictionary["response"]?.items,
                let friends = self.realm.objects
                
                else {
                    assertionFailure()
                    return
            }
            
            DispatchQueue.main.async {
                
                // Сравниваем полученное и кэш, убираем устаревшие элементы
                friends.enumerated().forEach { index, cacheItem in
                    
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
                    var objectIndex = friends.index(where: { $0.id == object.id })
                    var needReloadImage = true
                    
                    // Проверяем, изменился ли URL
                    if let objectIndex = objectIndex {
                        if friends[objectIndex].imagesURL == object.mainPhotoURL && self.images[objectIndex] != nil {
                            needReloadImage = false
                        }
                    } else { self.images.append(nil) }
                    
                    //Настраиваем Realm сущность Friends
                    let friend = Friends()
                    guard let url = URL(string: object.mainPhotoURL) else {
                        assertionFailure()
                        return
                    }
                    friend.name = object.firstName + " " + object.lastName
                    friend.id = object.id
                    friend.imagesURL = object.mainPhotoURL
                    
                    // Сохраняем в базу объект
                    self.realm.update(withObjects: [friend])
                    
                    if objectIndex == nil {
                        objectIndex = friends.count - 1
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


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let friends = self.realm.objects else { return cell }
        cell.textLabel?.text = friends[indexPath.row].name
        
        if self.images.count > 0 {
            cell.imageView?.image = self.images[indexPath.row] ?? UIImage(named: "noimage")
        } else {
            cell.imageView?.image = UIImage(named: "noimage")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "To Gallery", sender: indexPath)
    }
    
    // MARK: - Table View Control

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let objects = self.realm.objects {
            if self.images.count > objects.count {
                self.images.remove(at: indexPath.row)
            }
        }
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
