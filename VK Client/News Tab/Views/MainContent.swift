//
//  MainContent.swift
//  VK Client
//
//  Created by Денис on 06.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Neon

class MainContent: UIView {

    var textLabel = UILabel()
    var mainImageView = UIImageView(frame: .zero)
    private var imageContainer = UIView(frame: .zero)
    private let screen = UIScreen.main.bounds

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(aboveView: UIView) {

        let origin = CGPoint(x: aboveView.frame.origin.x, y: aboveView.frame.origin.y + aboveView.viewHeight)
        let frame = CGRect(origin: origin, size: .zero)
        super.init(frame: frame)

        self.backgroundColor = .green
        self.addSubview(textLabel)
        textLabel.font = UIFont(name: self.textLabel.font.familyName, size: 14)
    }
    
    func configure() {
        
//        self.frame = CGRect(x: 0, y: 0, width: screen.width, height: 60)
        
        textLabel.numberOfLines = 0

        print("mainContent.configure()")
        let size = textLabel.sizeThatFits(CGSize(width: screen.width, height: .greatestFiniteMagnitude))
        textLabel.frame.size = size
        self.frame.size = CGSize(width: screen.width,
                                 height: 5 + textLabel.viewHeight + 5)
        textLabel.anchorAndFillEdge(.top, xPad: 5, yPad: 5, otherSize: AutoHeight)

//        textLabel.anchorAndFillEdge(.top, xPad: 5, yPad: 5, otherSize: 50)
//        textLabel.sizeToFit()

        //        print("HeaderView: ", self.frame.size.height)
    }
}
