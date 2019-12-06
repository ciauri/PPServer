import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class PPSpotCount: SQLiteUUIDModel {
    var id: UUID?
    
    let levelID: String
    let availableSpots: Int
    let timestamp: Date
    
    init(level: PPLevel, date: Date) {
        levelID = level.id ?? ""
        availableSpots = level.currentCount
        timestamp = date
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension PPSpotCount: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension PPSpotCount: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension PPSpotCount: Parameter { }

extension PPSpotCount {
    var level: Parent<PPSpotCount, PPLevel> {
        return parent(\.levelID)
    }
}
