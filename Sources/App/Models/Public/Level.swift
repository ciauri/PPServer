//
//  Level.swift
//  App
//
//  Created by Stephen Ciauri on 12/6/19.
//

import Foundation
import Vapor
import PPKit

extension PPKLevel: Content {
    
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
