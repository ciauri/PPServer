//
//  SpotCount.swift
//  App
//
//  Created by Stephen Ciauri on 12/6/19.
//

import Foundation
import Vapor

struct SpotCount: Content {
    let id: UUID
    let levelID: String
    let availableSpots: Int
    let timestamp: Date
    
    init(with count: PPSpotCount) {
        id = count.id ?? .init()
        levelID = count.levelID
        availableSpots = count.availableSpots
        timestamp = count.timestamp
    }
}
