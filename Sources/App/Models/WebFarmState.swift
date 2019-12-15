//
//  WebService.swift
//  App
//
//  Created by Stephen Ciauri on 12/4/19.
//

import Foundation

struct WebFarmState: Codable {
    let centerLat: Double
    let centerLong: Double
    let latZoom: Double
    let longZoom: Double
    let structures: [Structure]
    
    enum CodingKeys: String, CodingKey {
        case centerLat = "CenterOnLatitude"
        case centerLong = "CenterOnLongitude"
        case latZoom = "LatitudeZoom"
        case longZoom = "LongitudeZoom"
        case structures = "Structures"
    }
    
    struct Structure: Codable {
        let name: String
        let address: String
        let capacity: Int
        let currentCount: Int
        let hdpiDetailImage: URL
        let mdpiDetailImage: URL
        let ldpiDetailImage: URL
        let latitude: Double
        let longitude: Double
        let timestamp: String
        let levels: [Level]
        
        var date: Date {
            let numbers = CharacterSet.alphanumerics.subtracting(.letters)
            guard let startRange = timestamp.rangeOfCharacter(from: numbers),
                let endRange = timestamp.range(of: "-") else {
                    return Date()
            }
            let millisecondString = timestamp[startRange.lowerBound ..< endRange.lowerBound]
            
            guard let millis = TimeInterval(millisecondString) else {
                return Date()
            }
            
            return Date(timeIntervalSince1970: millis/1000)
        }

        
        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case address = "Address"
            case capacity = "Capacity"
            case currentCount = "CurrentCount"
            case hdpiDetailImage = "HdpiDetailImage"
            case mdpiDetailImage = "MdpiDetailImage"
            case ldpiDetailImage = "LdpiDetailImage"
            case latitude = "Latitude"
            case longitude = "Longitude"
            case timestamp = "Timestamp"
            case levels = "Levels"
        }
        struct Level: Codable {
            let capacity: Int
            let currentCount: Int
            let friendlyName: String
            let systemName: String
            
            enum CodingKeys: String, CodingKey {
                case capacity = "Capacity"
                case currentCount = "CurrentCount"
                case friendlyName = "FriendlyName"
                case systemName = "SystemName"
            }
        }
    }
}
