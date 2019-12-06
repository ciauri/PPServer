//
//  Level.swift
//  App
//
//  Created by Stephen Ciauri on 12/6/19.
//

import Foundation
import Vapor

struct Level: Content {
    let id: String
    let structureID: String
    let name: String
    let systemName: String
    let capacity: Int
    let currentCount: Int
    
    init(with level: PPLevel) {
        id = level.id ?? ""
        structureID = level.structureID
        name = level.name
        systemName = level.systemName
        capacity = level.capacity
        currentCount = level.currentCount
    }
}
