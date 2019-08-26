//
//  UsersJSON.swift
//  EpicUS
//
//  Created by Denis Zubkov on 05/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct UsersJSON: Codable {
    let odataMetadata: String
    let value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    
    struct Value: Codable {
        let id, description, dataVersion, deptId: String
        let контактнаяИнформация: [КонтактнаяИнформация]
        let дополнительныеРеквизиты: [ДополнительныеРеквизиты]
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case description = "Description"
            case dataVersion = "DataVersion"
            case deptId = "Подразделение_Key"
            case контактнаяИнформация = "КонтактнаяИнформация"
            case дополнительныеРеквизиты = "ДополнительныеРеквизиты"
        }
    }
    
    struct ДополнительныеРеквизиты: Codable {
        let id, lineNumber, parameterId, value: String
        let valueType, textString: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case lineNumber = "LineNumber"
            case parameterId = "Свойство_Key"
            case value = "Значение"
            case valueType = "Значение_Type"
            case textString = "ТекстоваяСтрока"
        }
    }
    
    struct КонтактнаяИнформация: Codable {
        let id, lineNumber, type, value: String
        let email: String
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case lineNumber = "LineNumber"
            case type = "Тип"
            case value = "Представление"
            case email = "АдресЭП"
        }
    }
}
