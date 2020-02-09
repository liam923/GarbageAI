//
//  QRData.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

struct QRData: Codable {
    let trashType: TrashType
    let trashcanID: String
    let trashID: String
    let latitude: Double
    let longitude: Double
    let trashcanCounts: [String: Int]
}
