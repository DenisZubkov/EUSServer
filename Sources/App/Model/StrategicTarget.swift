//
//  StrategicTarget.swift
//  App
//
//  Created by Denis Zubkov on 12/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct StrategicTarget: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
}

extension StrategicTarget: MySQLUUIDModel {}
extension StrategicTarget: Migration {
}

