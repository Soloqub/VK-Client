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
    var bottomLeftPoint: CGPoint { return CGPoint(x: self.frame.origin.x,
                                                  y: self.frame.origin.y + self.frame.size.height) }
    
    func resizeToFitSubviews() {
        
        let subviewsRect = subviews.reduce(CGRect.zero) {
            $0.union($1.frame)
        }
        
        let fix = subviewsRect.origin
        subviews.forEach {
            $0.frame = $0.frame.offsetBy(dx: -fix.x, dy: -fix.y)
        }
        
        frame = frame.offsetBy(dx: fix.x, dy: fix.y)
        frame.size = subviewsRect.size
    }
}

extension UIColor {
    class func rgbColor(red: Int, green: Int, blue: Int) -> UIColor {

        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}

extension UIImage {
    var jpegToData: Data? {
        return UIImageJPEGRepresentation(self, 1)
    }
    var pngToData: Data? {
        return UIImagePNGRepresentation(self)
    }
}
