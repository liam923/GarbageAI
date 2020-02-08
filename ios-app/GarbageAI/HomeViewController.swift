//
//  HomeViewController.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        listener = Database.shared.getCounts { counts in
            var text = TrashType.getAll()
                .filter({(counts[$0] ?? -1) > 0})
                .map({ "\($0.pretty()): \(counts[$0]!)" })
                .joined(separator: "\n")
            text = text == "" ? "No trash yet" : text
            self.textView.text = text
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signIn", sender: self)
        } catch {
            // error occured signing out
        }
    }
    
    deinit {
        listener?.remove()
    }
    
}

