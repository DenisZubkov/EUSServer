//
//  UserStoryType.swift
//  App
//
//  Created by Denis Zubkov on 28/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct UserStoryType: Content {
    var id: UUID?
    var guid: String
    var name: String
    var type: String
}

extension UserStoryType: MySQLUUIDModel {}
extension UserStoryType: Migration {
}
