//
//  ParametersJSON.swift
//  EpicUS
//
//  Created by Denis Zubkov on 03/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct ParametersJSON: Decodable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    struct Value: Codable {
        let id, name, dataVersion: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case name = "Заголовок"
            case dataVersion = "DataVersion"
        }
    }

}

