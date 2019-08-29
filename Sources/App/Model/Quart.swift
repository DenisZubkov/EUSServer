//
//  Quart.swift
//  App
//
//  Created by Denis Zubkov on 29/08/2019.
//

import Foundation

import Fluent
import FluentMySQL
import Vapor

struct Quart: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
}

extension Quart: MySQLUUIDModel {}
extension Quart: Migration {
}
