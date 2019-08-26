//
//  Property.swift
//  App
//
//  Created by Denis Zubkov on 09/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Property: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
}

extension Property: MySQLUUIDModel {}
extension Property: Migration {
}
