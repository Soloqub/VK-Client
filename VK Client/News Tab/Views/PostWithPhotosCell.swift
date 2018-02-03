//
//  PostWithPhotosCell.swift
//  VK Client
//
//  Created by Денис Львович on 28.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import YogaKit

class PostWithPhotosCell: UITableViewCell {

    var header = HeaderView()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureLayout { layout in

            layout.isEnabled = true
            layout.height = 60
        }

        self.contentView.configureLayout { layout in

            layout.isEnabled = true
            layout.flexDirection = .column
            layout.width = YGValue(UIScreen.main.bounds.size.width)
            layout.height = 60
        }

        self.header = HeaderView(frame: CGRect(origin: self.contentView.frame.origin, size: self.contentView.frame.size))
        self.contentView.addSubview(header)

    }

    override func layoutSubviews() {

        self.yoga.applyLayout(preservingOrigin: true)
    }
}
