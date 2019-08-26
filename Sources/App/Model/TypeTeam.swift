//
//  TypeTeam.swift
//  App
//
//  Created by Denis Zubkov on 13/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct TypeTeam: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
}

extension TypeTeam: MySQLUUIDModel {}
extension TypeTeam: Migration {
}
