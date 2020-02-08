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
    
    func recordTrash(type: TrashType) {
        if let user = Auth.auth().currentUser {
            let doc = db.collection("users").document(user.uid)
            func update() {
                guard var counts = self.counts else { return }
                counts[type] = 1 + (counts[type] ?? 0)
                self.counts = counts
                doc.setData([type.rawValue: counts[type]!], merge: true)
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
