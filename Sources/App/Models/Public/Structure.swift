//
//  Structure.swift
//  App
//
//  Created by Stephen Ciauri on 12/5/19.
//

import Vapor
import Foundation
import PPKit
extension PPKStructure: Content {
    init(with structure: PPStructure, levels: [PPLevel], request: Request) {
        id = structure.id ?? ""
        name = structure.name
        capacity = structure.capacity
        currentCount = structure.currentCount
        lastUpdated = structure.lastUpdated
        hiResImageURL = structure.hiResImageURL
        lowResImageURL = structure.lowResImageURL
        latitude = structure.latitude
        longitude = structure.longitude
        self.levels = levels.map({ .init(with: $0, request: request) })
        links = [
            "href" : request.baseURL
                .appendingPathComponent("structure")
                .appendingPathComponent(id),
            "levels" : request.baseURL
                .appendingPathComponent("structure")
                .appendingPathComponent(id)
                .appendingPathComponent("levels")
        ]
    }
}
