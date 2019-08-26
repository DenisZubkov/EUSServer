//
//  BussinessValue.swift
//  App
//
//  Created by Denis Zubkov on 13/08/2019.
//

import Foundation

import Fluent
import FluentMySQL
import Vapor

struct BusinessValue: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var name: String
    var value: Int
    var days: Int
}

extension BusinessValue: MySQLUUIDModel {}
extension BusinessValue: Migration {
}
