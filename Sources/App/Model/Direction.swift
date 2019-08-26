//
//  Direction.swift
//  App
//
//  Created by Denis Zubkov on 14/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Direction: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
    var ord: Int32
    var small: String
    var tfsId: Int32
    var headId: String
}

extension Direction: MySQLUUIDModel {}
extension Direction: Migration {
}
