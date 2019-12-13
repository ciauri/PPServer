import Vapor

final class LevelController: RouteCollection {
    
    func boot(router: Router) throws {
        router.get("level", String.parameter, use: byId)
        router.get("level", String.parameter, "counts", use: counts)
    }
    
    func byId(_ req: Request) throws -> Future<Level> {
        return getLevel(with: req).map(to: Level.self) { (level) in
            return Level(with: level, request: req)
        }
    }
    
    func counts(_ req: Request) throws -> Future<[SpotCount]> {
        return
            getLevel(with: req)
                .flatMap { (level) -> EventLoopFuture<[PPSpotCount]> in
                    return try level.counts.query(on: req).all()
            }.map(to: [SpotCount].self) {
                $0.map({ SpotCount(with: $0) })
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
