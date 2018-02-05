//
//  PostWithPhotosCell.swift
//  VK Client
//
//  Created by Денис Львович on 28.01.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Neon

class PostWithPhotosCell: UITableViewCell {

    var header = HeaderView(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        self.contentView.addSubview(header)
//        self.contentView.backgroundColor = .brown
    }

    override func layoutSubviews() {

//        self.header.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: header.frame.height)
    }
}
