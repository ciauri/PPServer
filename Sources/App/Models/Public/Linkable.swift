//
//  Linkable.swift
//  App
//
//  Created by Stephen Ciauri on 12/13/19.
//

import Foundation
import Vapor

protocol Linkable {
    var links: [String: URL] { get }    
}
