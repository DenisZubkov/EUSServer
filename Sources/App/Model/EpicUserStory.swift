//
//  EpicUserStory.swift
//  App
//
//  Created by Denis Zubkov on 14/08/2019.
//


import Fluent
import FluentMySQL
import Vapor

struct EpicUserStory: Content {
    var id: UUID?
    var guid: String
    var dataVersion: String
    var dateBegin: Date?
    var dateCreate: Date?
    var dateEnd: Date?
    var deathLine: Date?
    var name: String
    var noShow: Bool
    var num: String
    var priority: Int32?
    var quart: String?
    var businessValueId: String
    var categoryId: String
    var deptId: String
    var directionId: String
    var productId: String?
    var productOwnerId: String
    var stateId: String?
    var tacticId: String
    var storePointsAnaliticFact: String?
    var storePointsAnaliticPlane: String?
    var storePointsDevFact: String?
    var storePointsDevPlane: String?
    var tfsAnalitic: String?
    var tfsBeginDate: Date?
    var tfsBusinessArea: String?
    var tfsBusinessValue: Int32?
    var tfsCategory: String?
    var tfsDateCreate: Date?
    var tfsEndDate: Date?
    var tfsId: Int32?
    var tfsLastChangeDate: Date?
    var tfsParentWorkItemUrl: String?
    var tfsPriority: Int32?
    var tfsProductOwner: String?
    var tfsQuart: Int32?
    var tfsState: String?
    var tfsStorePointAnaliticFact: Double?
    var tfsStorePointAnaliticPlan: Double?
    var tfsStorePointDevFact: Double?
    var tfsStorePointDevPlan: Double?
    var tfsStorePointFact: Double?
    var tfsStorePointPlan: Double?
    var tfsTitle: String?
    var tfsUrl: String?
    var tfsWorkItemType: String?
    var analiticId: String?
    
    
    
}
extension EpicUserStory: MySQLUUIDModel {}
extension EpicUserStory: Migration {
}
