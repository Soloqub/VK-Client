//
//  FriendsGalleryViewController.swift
//  VK Client
//
//  Created by Денис Львович on 03.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class FriendsGalleryViewController: UICollectionViewController {
    
    var friendsName:String = ""
    var ownerId = 0
    private let reuseIdentifier = "PhotoCell"
    private var token = ""
    
    var images = [UIImage?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Выводим имя выбранного друга в заголовке галлереи
        self.friendsName != "" ? self.navigationItem.title = friendsName : assertionFailure("Не передаётся имя пользователя в галлерею")
        self.token = KeychainWrapper.standard.string(forKey: "Token")!
        
        let provider = UserPhotosListProvider(token: self.token, ownerId: self.ownerId)
        print(self.ownerId)
        self.getUsersList(with: provider)
    }
    
    private func getUsersList(with provider: UserPhotosListProvider) {
        
        Alamofire.request(provider.makeURLRequest()!).responseData(queue: .global(qos: .userInitiated)) { response in

            guard
                let data = response.value,
                let myStructDictionary = try? JSONDecoder().decode([String: ResponseFriendsPhotosVK].self, from: data),
                let items = myStructDictionary["response"]?.items
                else { return }
            
            items.enumerated().forEach {
                let index = $0
                guard let url = URL(string: $1.photo) else {
                    assertionFailure()
                    return
                }

                self.images.append(nil)
                url.getPhoto() { image in
                    self.images[index] = image
                    self.collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }

            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.images.count >= 1 ? self.images.count : 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! FriendsPhotoCell
        
        cell.photoImageView.image = self.images.count < 1 ?
            UIImage(named: "noimage") :
            self.images[indexPath.row] ?? UIImage(named: "noimage")
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
