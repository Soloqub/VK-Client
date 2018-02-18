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

        textView.contentInsetAdjustmentBehavior = .automatic // Чтобы текст в textView отображался сверху, без отступа
        textView.becomeFirstResponder()
        self.addActionsBarOnKeyboard()
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let params: [String: Any] = ["message": textView.text]
        let provider = NewsListProvider(withType: .textPost(params: params))
        provider.post()
        
//        performSegue(withIdentifier: "unwindFromPost", sender: self)
    }
    
    private func addActionsBarOnKeyboard() {

        let actionsBar = UIToolbar()
        actionsBar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let placeImage = UIImage(named: "placement")
        let place = UIBarButtonItem(image: placeImage, style: .plain, target: self, action: #selector(self.placeButtonAction))
        
        let attachmentImage = UIImage(named: "attachment")
        let attach = UIBarButtonItem(image: attachmentImage, style: .plain, target: self, action: #selector(self.attachmentButtonAction))

        var items = [UIBarButtonItem]()
        items.append(contentsOf: [flexSpace, place, flexSpace, attach, flexSpace])
        actionsBar.items = items
        
        actionsBar.sizeToFit()
        textView.inputAccessoryView = actionsBar
    }
    
    @objc private func placeButtonAction() {
    }
    
    @objc private func attachmentButtonAction() {
    }
}
