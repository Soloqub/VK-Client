//
//  AboveView.swift
//  VK Client
//
//  Created by Денис Львович on 11.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

protocol AboveView where Self: UIView {

}

extension AboveView {

    func setOrigin(forAboveView aboveView: UIView) {
        let origin = CGPoint(x: aboveView.frame.origin.x, y: aboveView.frame.origin.y + aboveView.viewHeight)
        self.frame.origin = origin
    }
}
