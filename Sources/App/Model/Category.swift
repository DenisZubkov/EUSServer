//
//  Category.swift
//  App
//
//  Created by Denis Zubkov on 05/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Category: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
    var short: String
}

extension Category: MySQLUUIDModel {}
extension Category: Migration {
}
