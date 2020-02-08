//
//  SignInController.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class SignInController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let _ = user {
                self.performSegue(withIdentifier: "home", sender: self)
            }
        }
    }
    
}
