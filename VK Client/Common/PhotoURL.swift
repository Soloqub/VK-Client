//
//  PhotoURL.swift
//  VK Client
//
//  Created by Денис Львович on 15.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

struct PhotoURL {

    var value: URL

    init(_ value: URL) {
        self.value = value
    }

    func getPhoto(completion: @escaping (_ image: UIImage?) -> Void) {

        DispatchQueue.global().async {

            do {
                let data = try Data(contentsOf: self.value)

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
