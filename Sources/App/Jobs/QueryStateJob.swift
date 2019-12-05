//
//  QueryStateJob.swift
//  App
//
//  Created by Stephen Ciauri on 12/4/19.
//

import Foundation
import Vapor

class QueryStateJob: Worker {
    let app: Application
    let logger: Logger?
    let decoder = JSONDecoder()
    
    init(application: Application) {
        app = application
        logger = try? application.make(Logger.self)
    }
    
    func fetchState() {
        let url = URL(string: "https://webfarm.chapman.edu/parkingservice/parkingservice/counts")!
        HTTPClient.connect(hostname: url.host!, on: self).then { (client) -> EventLoopFuture<HTTPResponse> in
            let request = HTTPRequest(method: .GET, url: url)
            return client.send(request)
        }.flatMap { [decoder] (response) -> EventLoopFuture<Void> in
            if let data = response.body.data {
                let state = try? decoder.decode(WebFarmState.self, from: data)
                
                self.logger?.info("yay state")
            }
            return self.future()
        }
    }
    
    func shutdownGracefully(queue: DispatchQueue, _ callback: @escaping (Error?) -> Void) {
        
    }
    
    func next() -> EventLoop {
        return app.eventLoop
    }
}
