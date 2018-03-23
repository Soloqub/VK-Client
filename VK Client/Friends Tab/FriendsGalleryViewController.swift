//
//  FriendsGalleryViewController.swift
//  VK Client
//
//  Created by Денис Львович on 03.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import AlamofireImage

class FriendsGalleryViewController: UICollectionViewController {
    
    var friendsName: String = ""
    var ownerId = 0
    private let reuseIdentifier = "PhotoCell"
    private var urls = [URL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Выводим имя выбранного друга в заголовке галереи
        self.friendsName != "" ? self.navigationItem.title = friendsName : assertionFailure("Не передаётся имя пользователя в галерею")
        self.getUsersList()
    }
    
    private func getUsersList() {
        
        let provider = UserPhotosListProvider(withRouter: Router.sharedInstance)
        
        provider.getUserPhotos(withOwnerID: ownerId) { [weak self] urlStrings in

            for item in urlStrings {
                self?.urls.append((URL(string: item))!)
            }
            
            self?.collectionView?.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! FriendsPhotoCell
        
        cell.photoImageView.af_setImage(withURL: urls[indexPath.row],
                                         placeholderImage: UIImage(named: "noimage"),
                                         progressQueue: .global(qos: .userInteractive))
        
        return cell
    }
}
