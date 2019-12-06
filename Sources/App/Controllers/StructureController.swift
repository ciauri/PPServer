import Vapor

final class StructureController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get("structures", use: index)
        router.get("structure", String.parameter, use: byId)
        router.get("structure", String.parameter, "levels", use: levels)
    }
    
    func index(_ req: Request) throws -> Future<[Structure]> {
        return PPStructure.query(on: req)
            .all()
            .flatMap { (structures) -> EventLoopFuture<[Structure]> in
                try self.populate(structures: structures, for: req)
        }
    }
    
    func byId(_ req: Request) throws -> Future<Structure> {
        guard let id = (try? req.parameters.next(String.self)) ?? (try? req.query.get(String.self, at: "id")) else {
            return req.future(error: NotFound())
        }
        return PPStructure.find(id, on: req)
            .flatMap { (structure) -> EventLoopFuture<Structure> in
                guard let structure = structure else {
                    throw NotFound()
                }
                return try self.populate(structures: [structure], for: req).map(to: Structure.self) { populated in
                    return populated.first!
                }
        }
    }
    
    func levels(_ req: Request) throws -> Future<[Level]> {
        return try byId(req).map(to: [Level].self) { (structure) in
            return structure.levels
        }
    }
    
    private func populate(structures: [PPStructure], for req: Request) throws -> EventLoopFuture<[Structure]> {
        return try structures.map { (structure) -> EventLoopFuture<Structure> in
            try structure.levels.query(on: req).all()
                .map(to: Structure.self) { (levels) in
                    return Structure(with: structure, levels: levels)
            }
        }.flatten(on: req)
    }
}
