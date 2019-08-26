//
//  DeptsJSON.swift
//  EpicUS
//
//  Created by Dennis Zubkoff on 06/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct DeptsJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    
    struct Value: Codable {
        let id, description, parentId, dataVersion: String
        let дополнительныеРеквизиты: [ДополнительныеРеквизиты]
        let headId: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case description = "Description"
            case parentId = "Parent_Key"
            case dataVersion = "DataVersion"
            case дополнительныеРеквизиты = "ДополнительныеРеквизиты"
            case headId = "Руководитель_Key"
        }
    }
    
    struct ДополнительныеРеквизиты: Codable {
        let id, lineNumber, parameterId, value: String
        let valueType: String
        let textString: String
        
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case lineNumber = "LineNumber"
            case parameterId = "Свойство_Key"
            case value = "Значение"
            case valueType = "Значение_Type"
            case textString = "ТекстоваяСтрока"
        }
    }
}


