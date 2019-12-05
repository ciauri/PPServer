import FluentSQLite
import Vapor

/// A single entry of a Todo list.
final class PPLevel: SQLiteStringModel {
    /// The unique identifier for this `Todo`.
    var id: String?
    
    let structureID: String
    let name: String
    let systemName: String
    let capacity: Int
    let currentCount: Int
    


    /// Creates a new `Todo`.
//    init(id: Int? = nil, title: String) {
//        self.id = id
//        self.title = title
//    }
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
