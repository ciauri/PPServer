import Vapor
import PPKit

final class LevelController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get("level", String.parameter, use: byId)
        router.get("level", String.parameter, "counts", use: counts)
    }
    
    func byId(_ req: Request) throws -> Future<PPKLevel> {
        return getLevel(with: req).map(to: PPKLevel.self) { (level) in
            return PPKLevel(with: level, request: req)
        }
    }
    
    func counts(_ req: Request) throws -> Future<[PPKSpotCount]> {
        return
            getLevel(with: req)
                .flatMap { (level) -> EventLoopFuture<[PPSpotCount]> in
                    return try level.counts.query(on: req).all()
            }.map(to: [PPKSpotCount].self) {
                $0.map({ PPKSpotCount(with: $0) })
        }
    }
    
    private func getLevel(with req: Request) -> Future<PPLevel> {
        guard let id = (try? req.parameters.next(String.self)) ?? (try? req.query.get(String.self, at: "id")) else {
            return req.future(error: NotFound())
        }
        return PPLevel.find(id, on: req)
            .unwrap(or: NotFound())
    }
}
