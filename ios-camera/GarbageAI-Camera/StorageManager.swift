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
    
    static let shared = StorageManager(trashcanID: "AgbvuHAyPL7XOpFYOaHz")
    
    private let storeRef: StorageReference
    private let colRef: CollectionReference
    
    private init(trashcanID: String) {
        self.storeRef = Storage.storage().reference().child("trash-images").child(trashcanID)
        self.colRef = Firestore.firestore().collection("trashcans").document(trashcanID).collection("trash")
    }
    
    func upload(image: UIImage, completion: @escaping (Error?) -> Void) {
        let id = UUID().uuidString
        let time = Date()
        let imageRef = storeRef.child("\(id).jpg")
        imageRef.putData(image.jpegData(compressionQuality: 0.8)!, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error)
                return
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                } else if let url = url {
                    self.colRef.document(id).setData(["time" : time, "url": url.absoluteString]) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    completion(NSError())
                }
            }
        }
    }
    
}
