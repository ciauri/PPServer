import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class PPLevel: SQLiteUUIDModel {
    /// The unique identifier for this `Todo`.
    var id: UUID?
    
    let structureID: String
    var name: String
    var systemName: String
    var capacity: Int
    var currentCount: Int
    
    func update(with level: WebFarmState.Structure.Level) {
        name = level.friendlyName
        systemName = level.systemName
        capacity = level.capacity
        currentCount = level.currentCount
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension PPLevel: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension PPLevel: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension PPLevel: Parameter { }

extension PPLevel {
    var structure: Parent<PPLevel, PPStructure> {
        return parent(\.structureID)
    }
}
