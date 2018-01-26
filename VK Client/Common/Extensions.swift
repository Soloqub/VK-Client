//
//  Extensions.swift
//  VK Client
//
//  Created by Денис Львович on 30.11.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
//import Alamofire

extension UIViewController {
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

extension URL {
    func getPhoto(completion: @escaping (_ image: UIImage?) -> Void) {

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: self)
                guard let image = UIImage(data: data) else {
                    assertionFailure()
                    return
                }
                DispatchQueue.main.async { completion(image) }

            } catch {
                DispatchQueue.main.async { completion(nil) }
            }
        }
    }
}
