//
//  Database.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import Firebase

class Database {
    
    static let shared = Database()
    
    private let db: Firestore
    private var counts: [TrashType: Int]?
    
    private init() {
        self.db = Firestore.firestore()
    }
    
    func record(trash: QRData) {
        if let user = Auth.auth().currentUser {
            let doc = db.collection("users").document(user.uid)
            func update() {
                guard var counts = self.counts else { return }
                counts[trash.trashType] = 1 + (counts[trash.trashType] ?? 0)
                self.counts = counts
                doc.setData([trash.trashType.rawValue: counts[trash.trashType]!], merge: true)
            }
            if let _ = counts {
                update()
            } else {
                doc.getDocument { documentSnapshot, error in
                    guard let data = documentSnapshot?.data() else { return }
                    guard let counts = self.toTrashTypeDict(data: data) else { return }
                    self.counts = counts
                    update()
                }
            }
        }
        
        let doc = db.collection("trashcans").document(trash.trashcanID).collection("trash").document(trash.trashID)
        doc.updateData(["type": trash.trashType.rawValue])
    }
    
    func getCounts(handler: @escaping ([TrashType: Int]) -> Void) -> ListenerRegistration? {
        if let user = Auth.auth().currentUser {
            return db.collection("users").document(user.uid).addSnapshotListener { documentSnapshot, error in
                guard let data = documentSnapshot?.data() else { return }
                guard let counts = self.toTrashTypeDict(data: data) else { return }
                self.counts = counts
                handler(counts)
            }
        }
        return nil
    }
    
    private func toTrashTypeDict(data: [String: Any]) -> [TrashType: Int]? {
        var dict = [TrashType: Int]()
        for (key, val) in data {
            if let type = TrashType(rawValue: key), let count = val as? Int {
                dict[type] = count
            }
        }
        return dict
    }
    
}
