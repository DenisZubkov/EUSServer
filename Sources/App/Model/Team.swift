//
//  Team.swift
//  App
//
//  Created by Denis Zubkov on 13/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Team: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
    var typeTeamId: String
}

extension Team: MySQLUUIDModel {}
extension Team: Migration {
}
