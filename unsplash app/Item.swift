//
//  Item.swift
//  unsplash app
//
//  Created by paweł maryniak on 16/10/2024.
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
