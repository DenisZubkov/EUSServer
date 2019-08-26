//
//  PropertyValue.swift
//  App
//
//  Created by Denis Zubkov on 12/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct PropertyValue: Content {
    var id: UUID?
    var guid: String
    var isFolder: Bool
    var dataVersion: String
    var parentId: String
    var propertyId: String
    var value: String
}

extension PropertyValue: MySQLUUIDModel {}
extension PropertyValue: Migration {
}
