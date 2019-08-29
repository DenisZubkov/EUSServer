//
//  EUSStateJSON.swift
//  App
//
//  Created by Denis Zubkov on 29/08/2019.
//

import Foundation

struct EUSStateJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    
    struct Value: Codable {
        let id, name: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Документ_Key"
            case name = "ПредставлениеСостояния"
        }
    }
}
