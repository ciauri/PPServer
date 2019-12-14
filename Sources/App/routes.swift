import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    try router.register(collection: LevelController())
    try router.register(collection: StructureController())
}
