import Vapor
import PPKit

final class StructureController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get("structures", use: index)
        router.get("structure", String.parameter, use: byId)
        router.get("structure", String.parameter, "levels", use: levels)
    }
    
    func index(_ req: Request) throws -> Future<[PPKStructure]> {
        return PPStructure.query(on: req)
            .all()
            .flatMap { (structures) -> EventLoopFuture<[PPKStructure]> in
                try self.populate(structures: structures, for: req)
        }
    }
    
    func byId(_ req: Request) throws -> Future<PPKStructure> {
        guard let id = (try? req.parameters.next(String.self)) ?? (try? req.query.get(String.self, at: "id")) else {
            return req.future(error: NotFound())
        }
        return PPStructure.find(id, on: req)
            .unwrap(or: NotFound())
            .flatMap({ (structure) -> EventLoopFuture<[PPKStructure]> in
                return try self.populate(structures: [structure], for: req)
            }).map(to: PPKStructure.self) { $0.first! }
    }
    
    func levels(_ req: Request) throws -> Future<[PPKLevel]> {
        return try byId(req)
            .map(to: [PPKLevel].self) { $0.levels }
    }
    
    private func populate(structures: [PPStructure], for req: Request) throws -> EventLoopFuture<[PPKStructure]> {
        return try structures.map { (structure) -> EventLoopFuture<PPKStructure> in
            try structure.levels.query(on: req).all()
                .map(to: PPKStructure.self) { (levels) in
                    return PPKStructure(with: structure, levels: levels, request: req)
            }
        }.flatten(on: req)
    }
}
