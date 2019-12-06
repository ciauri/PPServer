//
//  Structure.swift
//  App
//
//  Created by Stephen Ciauri on 12/5/19.
//

import Vapor
import Foundation

struct Structure: Content {
    let id: String
    let name: String
    let capacity: Int
    let currentCount: Int
    let lastUpdated: Date
    let hiResImageURL: URL?
    let lowResImageURL: URL?
    let latitude: Double
    let longitude: Double
    let levels: [Level]
    
    init(with structure: PPStructure, levels: [PPLevel]) {
        id = structure.id ?? ""
        name = structure.name
        capacity = structure.capacity
        currentCount = structure.currentCount
        lastUpdated = structure.lastUpdated
        hiResImageURL = structure.hiResImageURL
        lowResImageURL = structure.lowResImageURL
        latitude = structure.latitude
        longitude = structure.longitude
        self.levels = levels.map({ .init(with: $0) })
    }
}
