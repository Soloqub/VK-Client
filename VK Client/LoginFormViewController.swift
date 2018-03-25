//
//  LoginFormViewController.swift
//  Weather
//
//  Created by Денис Львович on 16.10.17.
//  Copyright © 2017 Денис Львович. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
import Firebase

class LoginFormViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        self.showLogin()
    }
    
    func showLogin() {
        
        if let request = VKAuthProvider().makeURLRequest() {
            webView.load(request)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Enter" {
            KeychainWrapper.standard.set(self.token, forKey: "Token")
        }
    }

    private func addUserToFirebase() {

        DispatchQueue.global(qos: .userInteractive).async {

            let provider = UserInfoProvider(withRouter: Router.sharedInstance)
            provider.getSelfInfo{ id in

                let user = UserFB(id: id)
                let data = user.toAnyObject

                let dbLink = Database.database().reference()

                dbLink.child("Users").observe(DataEventType.value, with:
                    { (snapshot) in
                        guard let dict = snapshot.value as? [String: Any] else {
                            addElement(dbLink: dbLink, id: id, data: data)
                            return
                        }
                        if let _ = dict[id.description] {
                            return
                        } else {
                            addElement(dbLink: dbLink, id: id, data: data)
                        }
                })
            }

            func addElement(dbLink: DatabaseReference, id: Int, data: Any) {
                dbLink.child("Users").child(id.description).setValue(data)

                let defaults = UserDefaults.standard
                defaults.set(id, forKey: "CurrentUserID")
            }
        }
    }
    
    // MARK: - Delegate functions
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                
                decisionHandler(.allow)
                return
        }
        
        let params = VKAuthProvider.parseURLFragment(parameters: fragment)
        
        guard let token = params["access_token"] else {
            assertionFailure("токен не обнаружен")
            return
        }
        
        self.token = token
        
        decisionHandler(.cancel)
        performSegue(withIdentifier: "Enter", sender: nil)
        self.addUserToFirebase()
    }
}

