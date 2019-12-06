import Vapor

final class StructureController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[PPStructure]> {
        return PPStructure.query(on: req).all().flatMap { (levels) -> EventLoopFuture<[PPStructure]> in
            
            return req.future(levels)
        }
//        return PPStructure.query(on: req).all()
    }
}
