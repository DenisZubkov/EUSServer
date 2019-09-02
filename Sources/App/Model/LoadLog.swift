//
//  LoadLog.swift
//  App
//
//  Created by Denis Zubkov on 30/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct LoadLog: Content {
    var id: UUID?
    var date: Date
    var name: String
    var description: String?
    var Value: Int?
    var time: Double?
}

extension LoadLog: MySQLUUIDModel {}
extension LoadLog: Migration {
}
