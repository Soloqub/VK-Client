//
//  RealmHelper.swift
//  VK Client
//
//  Created by Денис Львович on 16.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import RealmSwift

class RealmHelper<T> where T: Object {

    var objects: Results<T>?
    private var token: NotificationToken?
    var delegate: RealmHelperDelegete?
    
    private func realmInit() -> Realm? {
        
        do {
            let realmContext = try Realm(fileURL: FileManager
                .default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.com.techranch.today")!
                .appendingPathComponent("db.realm"))
            return realmContext
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
    
    func update<T>(withObjects objects:[T]) where T: Object {
        
        guard let realm = self.realmInit() else { return }
        
        do {
            try realm.write {
                realm.add(objects, update: true) 
            }
            
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func deleteAll<T>(withType classType:T.Type) {
        
        guard let realm = self.realmInit() else { return }

        do {
            let oldEntities = realm.objects(classType as! Object.Type)
            
            try realm.write {
                realm.delete(oldEntities)
            }
            
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func delete<T>(objects:[T]) where T: Object  {
        
        guard let realm = self.realmInit() else { return }

        do {
            try realm.write {
                realm.delete(objects)
            }
            
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func fetchAll(withType classType:T.Type) {
        
        guard let realm = self.realmInit() else { return }

        self.objects = realm.objects(classType)
    }
    
    func fetchObject<T>(withType classType:T.Type, andID id:Int) -> T? where T: Object {
        
        guard let realm = self.realmInit() else { return nil }

        let result = realm.objects(classType).filter("id == %i", id)
        return result.isEmpty ? nil : result.first!
    }
    
    func printPath() {
        
        guard let realm = self.realmInit() else { return }
        
        print(realm.configuration.fileURL as Any)
    }
    
    func realmNotificationCenter(forTableView tableView: UITableView) {
        
        guard let objects = self.objects else { return }
        
        self.token = objects.observe { (changes: RealmCollectionChange) in
            
            switch changes {
                
            case .initial:
                tableView.reloadData()
                break
                
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
                
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
}

protocol RealmHelperDelegete {
    
    func onEvent()
}
