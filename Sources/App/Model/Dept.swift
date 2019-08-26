//
//  Dept.swift
//  App
//
//  Created by Denis Zubkov on 13/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Dept: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var parentId: String
    var headId: String
    var oracleId: String
    var name: String
}

extension Dept: MySQLUUIDModel {}
extension Dept: Migration {
}

