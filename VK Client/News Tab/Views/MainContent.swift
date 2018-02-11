//
//  MainContent.swift
//  VK Client
//
//  Created by Денис on 06.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit
import Neon

class MainContent: UIView, AboveView {

    var textLabel = UILabel()
    var mainImageView = UIImageView(frame: .zero)
    var mainImageSize = CGSize(width: 0, height: 0)
    var additionalImagesContainer = UIView(frame: .zero)
    var images = [UIImageView]()
    var imagesSizes = [CGSize]()
    private var imageContainer = UIView(frame: .zero)
    private let screen = UIScreen.main.bounds

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(textLabel)
        self.addSubview(imageContainer)
        textLabel.font = UIFont(name: self.textLabel.font.familyName, size: 14)
    }
    
    func configure() {
        
        textLabel.numberOfLines = 0
        let size = textLabel.sizeThatFits(CGSize(width: screen.width, height: .greatestFiniteMagnitude))
        textLabel.frame.size = size
        self.frame.size = CGSize(width: screen.width,
                                 height: 5 + textLabel.viewHeight + 5)
        textLabel.anchorAndFillEdge(.top, xPad: 5, yPad: 5, otherSize: AutoHeight)
        
        imageContainer.alignAndFillWidth(align: .underCentered, relativeTo: textLabel, padding: 5, height: 0)
        imageContainer.addSubview(mainImageView)
        imageContainer.addSubview(additionalImagesContainer)

        if mainImageSize.height != 0 && mainImageSize.width != 0 {
            let estimatedHeight = screen.width * mainImageSize.height / mainImageSize.width
            let mainImageHeight = estimatedHeight < screen.height * 0.6 ? estimatedHeight : screen.height * 0.6
            let mainImageWidth = mainImageHeight / estimatedHeight * screen.width
            mainImageView.anchorToEdge(.top, padding: 5, width: mainImageWidth, height: mainImageHeight)
        }
        
        let additionalImagesContainerHeight: CGFloat = imagesSizes.count > 0 ? 100 : 0
        additionalImagesContainer.align(.underCentered, relativeTo: mainImageView, padding: 5,
                                        width: screen.width, height: additionalImagesContainerHeight)
        if imagesSizes.count > 0 {
            for imageSize in imagesSizes {
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize.width * 100 / imageSize.height, height: 100 - 10))
                self.images.append(image)
                additionalImagesContainer.addSubview(image)
            }
            additionalImagesContainer.groupInCenter(group: .horizontal, views: images, padding: 5,
                                                    width: 100, height: 100)
        }

        imageContainer.resizeToFitSubviews()
        self.resizeToFitSubviews()
    }
}
