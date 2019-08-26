//
//  Tactic.swift
//  App
//
//  Created by Denis Zubkov on 13/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Tactic: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var strategicTargetId: String
    var name: String
}

extension Tactic: MySQLUUIDModel {}
extension Tactic: Migration {
}
