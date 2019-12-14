//
//  Level.swift
//  App
//
//  Created by Stephen Ciauri on 12/6/19.
//

import Foundation
import Vapor

struct Level: Content, Linkable {
    let links: [String : URL]
    
    let id: String
    let structureID: String
    let name: String
    let systemName: String
    let capacity: Int
    let currentCount: Int
    
    init(with level: PPLevel, request: Request) {
        id = level.id ?? ""
        structureID = level.structureID
        name = level.name
        systemName = level.systemName
        capacity = level.capacity
        currentCount = level.currentCount
        links = [
            "href" : request.baseURL
                .appendingPathComponent("level")
                .appendingPathComponent(id),
            "counts" : request.baseURL
                .appendingPathComponent("level")
                .appendingPathComponent(id)
                .appendingPathComponent("counts")
        ]
    }

}

extension Request {
    var baseURL: URL {
        let hostname = http.headers.firstValue(name: .host)!
        var scheme = "https"
        if let sslDisabled = Environment.get("PPS_SSL_DISABLED") {
            let sslDisabledString = NSString(string: sslDisabled)
            scheme = sslDisabledString.boolValue ? "http" : "https"
        }
        return URL(string: "\(scheme)://\(hostname)")!
    }
}
