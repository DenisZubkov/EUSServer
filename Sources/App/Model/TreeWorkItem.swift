//
//  TreeWorkItem.swift
//  App
//
//  Created by Denis Zubkov on 23/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct TreeWorkItem: Content {
    var id: UUID?
    var guid: Int
    var level: Int
    var parentId: Int
}

extension TreeWorkItem: MySQLUUIDModel {}
extension TreeWorkItem: Migration {
}

