//
//  FooterView.swift
//  VK Client
//
//  Created by Денис Львович on 11.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Neon

class FooterView: UIView, AboveView {

    var viewsLabel = UILabel(frame: .zero)
    var likesLabel = UILabel(frame: .zero)
    var repostsLabel = UILabel(frame: .zero)

    private let viewsContainer = UIView(frame: .zero)
    private let likesContainer = UIView(frame: .zero)
    private let repostsContainer = UIView(frame: .zero)

    private let viewsImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
    private let likesImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
    private let repostsImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
    private let separator = UIView(frame: .zero)

    private let screen = UIScreen.main.bounds

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size = CGSize(width: screen.width, height: 25)

        self.addSubview(viewsContainer)
        self.addSubview(likesContainer)
        self.addSubview(repostsContainer)

        viewsContainer.addSubview(viewsImage)
        viewsContainer.addSubview(viewsLabel)
        likesContainer.addSubview(likesImage)
        likesContainer.addSubview(likesLabel)
        repostsContainer.addSubview(repostsImage)
        repostsContainer.addSubview(repostsLabel)

        viewsLabel.font = UIFont(name: viewsLabel.font.familyName, size: 15)
        likesLabel.font = UIFont(name: likesLabel.font.familyName, size: 15)
        repostsLabel.font = UIFont(name: repostsLabel.font.familyName, size: 15)

        separator.backgroundColor = UIColor.rgbColor(red: 217, green: 217, blue: 217)
        self.addSubview(separator)
    }

    func configure() {

        viewsLabel.sizeToFit()
        viewsLabel.align(.toTheRightCentered, relativeTo: viewsImage, padding: 5, width: viewsLabel.width, height: viewsLabel.height)
        viewsImage.image = UIImage(named: "views")

        likesLabel.sizeToFit()
        likesLabel.align(.toTheRightCentered, relativeTo: likesImage, padding: 5, width: likesLabel.width, height: likesLabel.height)
        likesImage.image = UIImage(named: "likes")

        repostsLabel.sizeToFit()
        repostsLabel.align(.toTheRightCentered, relativeTo: repostsImage, padding: 5, width: repostsLabel.width, height: repostsLabel.height)
        repostsImage.image = UIImage(named: "reposts")

        viewsContainer.resizeToFitSubviews()
        likesContainer.resizeToFitSubviews()
        repostsContainer.resizeToFitSubviews()

        likesContainer.anchorToEdge(.left, padding: 20, width: likesContainer.width, height: likesContainer.height)
        repostsContainer.anchorToEdge(.right, padding: 20, width: repostsContainer.width, height: repostsContainer.height)
        viewsContainer.anchorInCenter(width: viewsContainer.width, height: viewsContainer.height)

        separator.frame = CGRect(x: 20, y: self.height, width: screen.width, height: 1)
    }
}
