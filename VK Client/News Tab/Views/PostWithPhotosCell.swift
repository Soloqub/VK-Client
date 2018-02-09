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

//    var header = HeaderView(frame: .zero)
//    var mainContent = MainContent(frame: .zero)

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
//        self.configure()
//        self.contentView.addSubview(header)
    }

    override func layoutSubviews() {

//        self.header.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: header.frame.height)
//        self.configure()
    }

    func configure() {

//        self.contentView.groupAgainstEdge(group: .vertical, views: [header, mainContent], againstEdge: .top,
//                                          padding: 2, width: UIScreen.main.bounds.size.width, height: AutoHeight)

//        print("header.viewHeight: ", self.header.viewHeight)
//        print("mainContent.viewHeight: ", self.mainContent.viewHeight)
//        print("header.viewWidth: ", self.header.viewWidth)
//        print("mainContent.viewWidth: ", self.mainContent.viewWidth)
    }
}
