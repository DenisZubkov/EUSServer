//
//  ParameterValuesJSON.swift
//  App
//
//  Created by Denis Zubkov on 12/08/2019.
//

struct ParameterValuesJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    struct Value: Codable {
        let id, value, parameterId, parentId, dataVersion: String
        let isFolder: Bool
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case value = "Description"
            case parameterId = "Owner_Key"
            case parentId = "Parent_Key"
            case dataVersion = "DataVersion"
            case isFolder = "IsFolder"
        }
    }
    
}
