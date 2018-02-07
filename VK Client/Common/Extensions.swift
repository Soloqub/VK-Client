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

extension Date {
    func vkDateFormatter() -> String {
        
        let vkDateFormater = DateFormatter()
        vkDateFormater.locale = Locale(identifier: "ru_RU")
        vkDateFormater.dateFormat = "dd MMM в HH:mm"

        return vkDateFormater.string(from: self)
    }
}

extension UIView {
    var viewHeight: CGFloat { return self.frame.size.height }
    var viewWidth: CGFloat { return self.frame.size.width }
}

extension UIColor {
    class func rgbColor(red: Int, green: Int, blue: Int) -> UIColor {

        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
