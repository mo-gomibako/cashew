//
//  Item.swift
//  cashew
//
//  Created by mog on 2024/02/01.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
