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
            
            doc.collection("trash").addDocument(data: ["trashcanId": trash.trashcanID, "type": trash.trashType.rawValue, "location": GeoPoint(latitude: trash.latitude, longitude: trash.longitude), "time": Date()])
        }
        
        let doc = db.collection("trash").document(trash.trashID)
        doc.updateData(["type": trash.trashType.rawValue])
        
        db.collection("trashcan").document(trash.trashcanID).updateData(["counts": trash.trashcanCounts])
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
    
    func getHistory(handler: @escaping ([Trash]) -> Void) {
        if let user = Auth.auth().currentUser {
            db.collection("users").document(user.uid).collection("trash").addSnapshotListener { snapshot, error in
                var trash = [Trash]()
                for doc in snapshot?.documents ?? [] {
                    let data = doc.data()
                    if let id = (data["trashcanId"] ?? 0) as? String, let typeStr = (data["type"] ?? 0) as? String, let type = TrashType(rawValue: typeStr), let point = (data["location"] ?? 0) as? GeoPoint, let time = ((data["time"] ?? 0) as? Timestamp)?.dateValue() {
                        trash.append(Trash(type: type, location: point, trashcanID: id, time: time))
                    } else {
                        return
                    }
                }
                handler(trash)
            }
        }
    }
    
    func getLocations(handler: @escaping ([GeoPoint]) -> Void) {
        db.collection("trashcans").getDocuments { (snapshot, error) in
            if let docs = snapshot?.documents {
                var points = [GeoPoint]()
                for doc in docs {
                    if let point = doc.data()["location"] as? GeoPoint {
                        points.append(point)
                    }
                }
                handler(points)
            }
        }
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
