//
//  QueryStateJob.swift
//  App
//
//  Created by Stephen Ciauri on 12/4/19.
//

import Foundation
import Vapor
import SQLite

class QueryStateJob: Worker {
    let app: Application
    let logger: Logger?
    let decoder = JSONDecoder()
    let dbConnection: SQLiteDatabase.Connection
    
    init(application: Application) {
        app = application
        logger = try? application.make(Logger.self)
        dbConnection = try! app.newConnection(to: PPStructure.defaultDatabase!).wait()
    }
    
    func fetchState() {
        let url = URL(string: "https://webfarm.chapman.edu/parkingservice/parkingservice/counts")!
        HTTPClient.connect(hostname: url.host!, on: self).then { (client) -> EventLoopFuture<HTTPResponse> in
            let request = HTTPRequest(method: .GET, url: url)
            return client.send(request)
        }.flatMap { [decoder, app] (response) -> EventLoopFuture<Void> in
            if let data = response.body.data {
                let state = try decoder.decode(WebFarmState.self, from: data)
                self.logger?.info("yay state")
                return try self.process(structures: state.structures)
            }
            return self.future()
        }
    }
    
    func process(structures: [WebFarmState.Structure]) throws -> EventLoopFuture<Void> {
        let futures: [EventLoopFuture<Void>] = structures.map { (structure) -> EventLoopFuture<Void> in
            return PPStructure.find(structure.name, on: self.dbConnection).flatMap { (dbStructure) -> EventLoopFuture<Void> in
                if let dbStructure = dbStructure {
                    return try self.merge(state: structure, with: dbStructure)
                }
            }
        }
    }
    
    func merge(state: WebFarmState.Structure, with structure: PPStructure) throws -> EventLoopFuture<Void> {
        structure.update(with: state)
        return try structure.levels.query(on: dbConnection).all().flatMap { (dbLevels) -> EventLoopFuture<Void> in
            dbLevels.forEach { (level) in
                if let matchingLevel = state.levels.first(where: {$0.systemName == level.systemName}) {
                    level.update(with: matchingLevel)
                }
            }
        }

    }
    
    func shutdownGracefully(queue: DispatchQueue, _ callback: @escaping (Error?) -> Void) {
        
    }
    
    func next() -> EventLoop {
        return app.eventLoop
    }
}
