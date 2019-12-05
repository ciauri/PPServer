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
    
    func sync() {
        app.eventLoop.scheduleRepeatedTask(initialDelay: TimeAmount.seconds(0), delay: TimeAmount.minutes(5)) { task -> EventLoopFuture<Void> in
            self.fetchState()
                .map { (state) -> (state: [WebFarmState.Structure], structures: [PPStructure]) in
                    return (state.structures, state.structures.map({ PPStructure(with: $0) }))
            }.map { (context) -> (structures: [PPStructure], levels: [PPLevel]) in
                let levels = context.state
                    .map { (structure) -> [PPLevel] in
                        return structure.levels.map({ PPLevel(with: $0, structureID: structure.name) })
                }.reduce([], +)
                return (context.structures, levels)
            }.flatMap { (context) -> (EventLoopFuture<Void>) in
                return EventLoopFuture.andAll(context.structures.map { $0.upsert(on: self.dbConnection) }, eventLoop: self.next())
                    .do { (_) in
                        context.levels.map({ $0.upsert(on: self.dbConnection).catch { (error) in
                            self.logger?.error("whooops")
                            } })
                }.catch { (error) in
                    self.logger?.error("whooops")
                }
            }
        }
    }
    
    private func fetchState() -> EventLoopFuture<WebFarmState> {
        let url = URL(string: "https://webfarm.chapman.edu/parkingservice/parkingservice/counts")!
        return HTTPClient.connect(hostname: url.host!, on: self).then { (client) -> EventLoopFuture<HTTPResponse> in
            let request = HTTPRequest(method: .GET, url: url)
            return client.send(request)
        }.map(to: WebFarmState.self) { [decoder] (response) in
            if let data = response.body.data {
                return try decoder.decode(WebFarmState.self, from: data)
            } else {
                throw VaporError(identifier: "Decoding", reason: "WebFarm response is nil")
            }
        }
    }
    
    func shutdownGracefully(queue: DispatchQueue, _ callback: @escaping (Error?) -> Void) {
        
    }
    
    func next() -> EventLoop {
        return app.eventLoop
    }
}
