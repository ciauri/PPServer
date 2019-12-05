import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class PPStructure: SQLiteStringModel {
    /// The unique identifier for this `Todo`.
    var id: String?
    var name: String
    var capacity: Int
    var currentCount: Int
    var lastUpdated: Date
    var hiResImageURL: URL?
    var lowResImageURL: URL?
    var latitude: Double
    var longitude: Double

    func update(with state: WebFarmState.Structure) {
        name = state.name
        capacity = state.capacity
        currentCount = state.currentCount
        hiResImageURL = state.hdpiDetailImage
        lowResImageURL = state.ldpiDetailImage
        latitude = state.latitude
        longitude = state.longitude
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension PPStructure: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension PPStructure: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension PPStructure: Parameter { }

extension PPStructure {
    var levels: Children<PPStructure, PPLevel> {
        return children(\.structureID)
    }
}
