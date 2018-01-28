//
//  EntitiesProtocols.swift
//  VK Client
//
//  Created by Денис Львович on 10.12.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit

protocol ImageCollectionCompatible {
    
    var images: [UIImage?] {get set}
}

extension ImageCollectionCompatible {
    
    func getPhoto(by url:URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        DispatchQueue.global().async {
            
            do {

                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {

                    guard let image = UIImage(data: data) else {
                        assertionFailure()
                        return
                    }
                    completion(image)
                }
            } catch {
                completion(nil)
            }
        }
    }
}
