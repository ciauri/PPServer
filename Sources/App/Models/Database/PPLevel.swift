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
    
    init(with level: WebFarmState.Structure.Level, structureID: PPStructure.ID) {
        id = structureID + level.systemName
        self.structureID = structureID
        name = level.friendlyName
        systemName = level.systemName
        capacity = level.capacity
        currentCount = level.currentCount
    }
    
    func didUpdate(on conn: SQLiteConnection) throws -> EventLoopFuture<PPLevel> {
        structure.query(on: conn).first().do { (structure) in
            if let structure = structure {
                PPSpotCount(level: self, date: structure.lastUpdated).save(on: conn)
            }
        }.map(to: PPLevel.self) { (_)  in
            return self
        }
        
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

extension PPLevel {
    var counts: Children<PPLevel, PPSpotCount> {
        return children(\.levelID)
    }
}

extension Model {
    func upsert(on db: DatabaseConnectable) -> EventLoopFuture<Self> {
        return create(on: db).catchFlatMap { (_) -> (EventLoopFuture<Self>) in
            return self.update(on: db)
        }
    }
}
