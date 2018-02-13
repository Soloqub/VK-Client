//
//  WallPostVC.swift
//  VK Client
//
//  Created by Денис Львович on 12.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

class WallPostVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fontConfigure()
        textView.contentInsetAdjustmentBehavior = .automatic // Чтобы текст в textView отображался сверху, без отступа
        textView.becomeFirstResponder()
        self.addActionsBarOnKeyboard()
    }

    private func fontConfigure() {
        let font = UIFont.systemFont(ofSize: 19.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.2

        let attrText = NSMutableAttributedString(string: "")
        attrText.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: attrText.length))

        attrText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrText.length))
        textView.attributedText = attrText
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let params: [String: Any] = ["message": textView.text]
        let config = NewsListProvider.makeConfig(forType: .textPost(params: params))
        let provider = NewsListProvider(config: config)
        provider.post()
        
//        performSegue(withIdentifier: "unwindFromPost", sender: self)
    }
    
    private func addActionsBarOnKeyboard() {
        let screenWidth = UIScreen.main.bounds.size.width
        
        let actionsBar: UIToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0))
        actionsBar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let placeButton = UIButton()
        placeButton.setImage(UIImage(named: "placement"), for: .normal)
        placeButton.addTarget(self, action: #selector(self.placeButtonAction), for: UIControlEvents.touchUpInside)
        placeButton.sizeToFit()
        let place = UIBarButtonItem(customView: placeButton)
        
        let attachmentButton = UIButton()
        attachmentButton.setImage(UIImage(named: "attachment"), for: .normal)
        attachmentButton.addTarget(self, action: #selector(self.attachmentButtonAction), for: UIControlEvents.touchUpInside)
        attachmentButton.sizeToFit()
        let attach = UIBarButtonItem(customView: attachmentButton)
        
        var items = [UIBarButtonItem]()
        
        items.append(flexSpace)
        items.append(place)
        items.append(flexSpace)
        items.append(attach)
        items.append(flexSpace)
        
        actionsBar.items = items
        
        actionsBar.sizeToFit()
        textView.inputAccessoryView = actionsBar
    }
    
    @objc private func placeButtonAction() {
    }
    
    @objc private func attachmentButtonAction() {
    }
}
