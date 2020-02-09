//
//  TrashType.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation

enum TrashType: String, Codable {
    case trash, paper, metal, glass, plastic, cardboard
    
    static func getAll() -> [TrashType] {
        return [.trash, .paper, .metal, .glass, .plastic, .cardboard]
    }
    
    func pretty() -> String {
        switch self {
        case .trash:
            return "Trash"
        case .paper:
            return "Paper"
        case .metal:
            return "Metal"
        case .glass:
            return "Glass"
        case .plastic:
            return "Plastic"
        case .cardboard:
            return "Cardboard"
        }
    }
}
