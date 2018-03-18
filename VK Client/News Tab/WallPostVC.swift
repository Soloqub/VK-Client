//
//  WallPostVC.swift
//  VK Client
//
//  Created by Денис Львович on 12.02.18.
//  Copyright © 2018 Денис Львович. All rights reserved.
//

import UIKit

class WallPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    private var provider = NewsListProvider()
    private let imagePicker = UIImagePickerController()
    private var imageAttachment: SaveImageResponseVK.Success?
    
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
        
        var params: [String: Any] = ["message": textView.text]
        if let attach = self.imageAttachment {
            params["attachments"] = "photo\(attach.ownerID.description)_\(attach.mediaID.description)"
        }
        provider.post(withParams: params) { [weak self] success, error in

            if success { self?.performSegue(withIdentifier: "postUnwind", sender: self) } else {

                // Выводим сообщение
                let title = "Ошибка \(error?.code ?? 0)"
                let message = error?.message
                let textAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                textAlert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.cancel, handler: nil))

                self?.present(textAlert, animated: true, completion: nil)
            }
        }
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

        self.imagePicker.delegate = self

        let alert = UIAlertController(title: "Выберите изображение", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Сохранённые изображения", style: .default, handler: { _ in
            self.openLibrary()
        }))
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    private func openCamera() {

        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Внимание!", message: "Камера недоступна на этом устройстве", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func openLibrary() {

        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = false
        self.present(self.imagePicker, animated: true, completion: nil)
    }

    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            let alert  = UIAlertController(title: "Внимание!", message: "Не получилось загрузить данное изображение", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

            return
        }

        self.provider.upload(photoToVK: image) { imageObject in
            self.imageAttachment = imageObject
        }

        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
