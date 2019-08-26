//
//  WorkItemJSON.swift
//  App
//
//  Created by Denis Zubkov on 08/08/2019.
//

import Foundation

struct WorkItemJSON: Codable {
    let id, rev: Int
    let fields: FieldsClass
    let relations: [Relation]
    
    enum CodingKeys: String, CodingKey {
        case id, rev, fields, relations
    }
    
    
    struct FieldsClass: Codable {
        let teamName: String?
        let sprintName: String?
        let workItemType: String?
        let state: String?
        let productOwner: String?
        let createdDate: String?
        let title: String?
        let stateChangeDate: String?
        let lastChangeDate: String?
        let endDate: String?
        let businessArea: String?
        let businessValue: Int?
        let priority: Int?
        let beginDate: String?
        let analiticName: String?
        let categoryName: String?
        let storePointsPlan: Double?
        let storePointsAnaliticPlan: Double?
        let storePointsDevPlan: Double?
        let storePointsFact: Double?
        let storePointsAnaliticFact: Double?
        let storePointsDevFact: Double?
        let kvartal: Int?
        
        
        enum CodingKeys: String, CodingKey {
            case teamName = "System.AreaPath"
            case sprintName = "System.IterationPath"
            case workItemType = "System.WorkItemType"
            case state = "System.State"
            case productOwner = "System.AssignedTo"
            case createdDate = "System.CreatedDate"
            case title = "System.Title"
            case stateChangeDate = "Microsoft.VSTS.Common.StateChangeDate"
            case lastChangeDate = "System.ChangedDate"
            case endDate = "Microsoft.VSTS.Common.ClosedDate"
            case businessArea = "Microsoft.VSTS.Common.ValueArea"
            case businessValue = "Microsoft.VSTS.Common.BusinessValue"
            case priority = "Microsoft.VSTS.Common.Priority"
            case beginDate = "TBM.EpiReceiptDate"
            case analiticName = "TBM.EpiAnalist"
            case categoryName = "TBM.EpiCategory"
            case storePointsPlan = "TBM.EpiPreEffort"
            case storePointsAnaliticPlan = "TBM.EpiPreEffortOA"
            case storePointsDevPlan = "TBM.EpiPreEffortORPO"
            case storePointsFact = "Microsoft.VSTS.Scheduling.Effort"
            case storePointsAnaliticFact = "TBM.EpiFactEffortOA"
            case storePointsDevFact = "TBM.EpiFactEffortORPO"
            case kvartal = "TBM.EpiKvartal"
        }
    }
    
    
    
    
    struct Relation: Codable {
        let rel: String
        let url: String
    }
    
}
