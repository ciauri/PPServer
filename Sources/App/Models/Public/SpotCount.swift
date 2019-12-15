//
//  SpotCount.swift
//  App
//
//  Created by Stephen Ciauri on 12/6/19.
//

import Foundation
import Vapor
import PPKit

extension PPKSpotCount: Content {
    init(with count: PPSpotCount) {
        id = count.id ?? .init()
        levelID = count.levelID
        availableSpots = count.availableSpots
        timestamp = count.timestamp
    }
}
