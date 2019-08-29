//
//  UserStory.swift
//  App
//
//  Created by Denis Zubkov on 28/08/2019.
//

import Fluent
import FluentMySQL
import Vapor

struct UserStory: Content {
    var id: UUID?
    var guid: String
    var dateBegin: Date?
    var dateCreate: Date?
    var dateEnd: Date?
    var priority: Int32?
    var storePointsFact: String?
    var storePointsPlan: String?
    var tfsLastChangeDate: Date?
    var tfsSprintName: String?
    var tfsStateName: String?
    var tfsTeamName: String?
    var title: String?
    var analiticId: String?
    var stateId: String?
    var teamId: String?
    var userStoryTypeId: String?

    
    
    
}
extension UserStory: MySQLUUIDModel {}
extension UserStory: Migration {
}
