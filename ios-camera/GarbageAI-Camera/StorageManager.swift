//
//  StorageManager.swift
//  GarbageAI-Camera
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import Firebase

class StorageManager {
    
    static let shared = StorageManager()
    
    let ref: StorageReference
    
    private init() {
        self.ref = Storage.storage().reference().child("trash-images")
    }
    
}
