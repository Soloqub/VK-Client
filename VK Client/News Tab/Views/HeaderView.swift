//
//  HeaderView.swift
//  VK Client
//
//  Created by Денис Львович on 03.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import YogaKit

class HeaderView: UIView {

    var avatar = UIImageView()
    var nameLabel = UILabel(frame: .zero)
    var dateLabel = UILabel(frame: .zero)

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        self.backgroundColor = .gray
        self.configure(view: self, withID: .selfView)

        self.configure(view: self.avatar, withID: .avatar)
        self.avatar.backgroundColor = .red
        self.addSubview(self.avatar)

        let nameAndDateSubview = UIView()
        nameAndDateSubview.backgroundColor = .green
        self.configure(view: nameAndDateSubview, withID: .nameAndDate)
        self.addSubview(nameAndDateSubview)

        self.nameLabel.font = UIFont(name: self.nameLabel.font.familyName, size: 18)
        self.nameLabel.textColor = UIColor.blue
        self.dateLabel.font = UIFont(name: self.dateLabel.font.familyName, size: 14)
        self.dateLabel.textColor = UIColor.gray

        self.configure(view: self.nameLabel, withID: .name)
        self.configure(view: self.dateLabel, withID: .date)

        nameAndDateSubview.addSubview(self.nameLabel)
        nameAndDateSubview.addSubview(self.dateLabel)

    }

    override func layoutSubviews() {

        self.yoga.applyLayout(preservingOrigin: true)

        self.nameLabel.sizeToFit()

        self.avatar.layer.cornerRadius = self.avatar.frame.size.width / 2
        self.avatar.clipsToBounds = true
    }

    func configure(view: UIView, withID id: ViewID) {

        view.configureLayout { layout in

            layout.isEnabled = true

            switch id {
            case .selfView:
                layout.flexDirection = .row
                layout.width = YGValue(UIScreen.main.bounds.size.width)
                layout.height = 60

            case .avatar:
                layout.width = 50
                layout.aspectRatio = 1
                layout.marginHorizontal = 10
                layout.marginVertical = 5

            case .nameAndDate:
                layout.flexDirection = .column
                layout.width = 50
                layout.flexGrow = 1
                layout.paddingLeft = 10
                layout.paddingVertical = 10

            case .name:
                layout.marginBottom = 2

            case .date:
                break
            }
        }
    }

    enum ViewID {

        case selfView, avatar, nameAndDate, name, date
    }
}
