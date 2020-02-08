//
//  ReplaceSegue.swift
//  GarbageAI
//
//  Created by Liam Stevenson on 2/8/20.
//  Copyright © 2020 Liam Stevenson. All rights reserved.
//

import Foundation
import UIKit

class ReplaceSegue: UIStoryboardSegue {
    
    override func perform() {
        source.navigationController?.popToRootViewController(animated: false)
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
}
