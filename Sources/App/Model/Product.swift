//
//  Product.swift
//  App
//
//  Created by Denis Zubkov on 26/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Product: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
    var tfsId: Int
    var productOwnerId: String
    var directionId: String
}

extension Product: MySQLUUIDModel {}
extension Product: Migration {
}
