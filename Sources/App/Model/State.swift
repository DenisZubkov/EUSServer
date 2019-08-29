//
//  State.swift
//  App
//
//  Created by Denis Zubkov on 28/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct State: Content {
    var id: UUID?
    var guid: String
    var name: String
}

extension State: MySQLUUIDModel {}
extension State: Migration {
}
