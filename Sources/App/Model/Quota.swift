//
//  Quota.swift
//  App
//
//  Created by Denis Zubkov on 14/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct Quota: Content {
    var id: UUID?
    var quart: Date
    var storePointAnaliticPlan: Double
    var storePointAnaliticFact: Double
    var storePointAnaliticWork: Double
    var storePointDevPlan: Double
    var storePointDevFact: Double
    var storePointDevWork: Double
    var directionId: String
}

extension Quota: MySQLUUIDModel {}
extension Quota: Migration {
}
