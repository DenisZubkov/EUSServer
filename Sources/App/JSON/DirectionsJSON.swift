//
//  DirectionsJSON.swift
//  EpicUS
//
//  Created by Denis Zubkov on 30/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct DirectionsJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    
    struct Value: Codable {
        let id, name, dataVersion, ord: String
        let shortName, userId: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case name = "Description"
            case dataVersion = "DataVersion"
            case ord = "ПорядокСортировки"
            case shortName = "КраткоеНаименование"
            case userId = "РуководительНаправления_Key"
        }
    }
}
