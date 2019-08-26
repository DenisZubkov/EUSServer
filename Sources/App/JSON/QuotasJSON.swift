//
//  QuotasJSON.swift
//  EpicUS
//
//  Created by Denis Zubkov on 24/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct QuotasJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    struct Value: Codable {
        let quart: String
        let directionId: String
        let storePointAnaliticPlan: Double
        let storePointAnaliticWork: Double
        let storePointAnaliticFact: Double
        let storePointDevPlan: Double
        let storePointDevWork: Double
        let storePointDevFact: Double
        
        enum CodingKeys: String, CodingKey {
            case quart = "Period"
            case directionId = "НаправлениеРазвитияПО_Key"
            case storePointAnaliticPlan = "ТрудозатратыОАПлан"
            case storePointAnaliticWork = "ОАВзятоВРаботу"
            case storePointAnaliticFact = "ТрудозатратыОАФакт"
            case storePointDevPlan = "ТрудозатратыОРПОПлан"
            case storePointDevWork = "ОРПОВзятоВРаботу"
            case storePointDevFact = "ТрудозатратыОРПОФакт"
        }
    }

}


