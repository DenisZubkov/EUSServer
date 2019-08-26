//
//  User.swift
//  App
//
//  Created by Denis Zubkov on 13/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct User: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var fio: String
    var email: String
    var oracleId: String
    var phone: String
    var deptId: String
    var teamId: String
    var headId: String
}

extension User: MySQLUUIDModel {}
extension User: Migration {
}
