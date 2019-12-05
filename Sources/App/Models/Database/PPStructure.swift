import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class PPStructure: SQLiteStringModel {
    /// The unique identifier for this `Todo`.
    var id: String?

    let name: String
    let capacity: Int
    let currentCount: Int
    let lastUpdated: Date
    let hiResImageURL: URL?
    let lowResImageURL: URL?
    let latitude: Double
    let longitude: Double

    /// Creates a new `Todo`.
//    init(id: Int? = nil, title: String) {
//        self.id = id
//        self.title = title
//    }
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
