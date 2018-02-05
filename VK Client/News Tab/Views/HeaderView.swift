//
//  HeaderView.swift
//  VK Client
//
//  Created by Денис Львович on 03.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Neon

class HeaderView: UIView {

    var avatar = UIImageView()
    var nameLabel = UILabel(frame: .zero)
    var dateLabel = UILabel(frame: .zero)

    private let nameAndDate = UIView(frame: .zero)
    private let screen = UIScreen.main.bounds

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.addSubview(self.avatar)
        self.addSubview(nameAndDate)
        nameAndDate.addSubview(self.nameLabel)
        nameAndDate.addSubview(self.dateLabel)

        nameLabel.font = UIFont(name: self.nameLabel.font.familyName, size: 18)
        dateLabel.font = UIFont(name: self.dateLabel.font.familyName, size: 14)
        nameLabel.textColor = .blue
        dateLabel.textColor = .gray
    }


    func configure() {

//        self.fillSuperview()
        self.frame = CGRect(x: 0, y: 0, width: screen.width, height: 60)
        self.backgroundColor = .gray

        avatar.anchorAndFillEdge(.left, xPad: 10, yPad: 5, otherSize: 50)
        avatar.backgroundColor = .red
        avatar.layer.cornerRadius = self.avatar.frame.size.width / 2
        avatar.clipsToBounds = true

        nameAndDate.backgroundColor = .green
        nameAndDate.alignAndFill(align: .toTheRightCentered, relativeTo: self.avatar, padding: 0)
        nameAndDate.frame.origin.x += 10
        nameAndDate.frame.size.width -= 10

        nameLabel.sizeToFit()
        dateLabel.sizeToFit()
        nameAndDate.groupAndFill(group: .vertical, views: [self.nameLabel, self.dateLabel], padding: 5)
        nameLabel.frame.origin.y += 2
        dateLabel.frame.origin.y -= 2
        print("HeaderView: ", self.frame.size.height)
    }
}
