//
//  Trash.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/9/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import Firebase

struct Trash {
    let type: TrashType
    let location: GeoPoint
    let trashcanID: String
    let time: Date
}
