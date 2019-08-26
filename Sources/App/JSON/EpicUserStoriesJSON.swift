//
//  EpicUserStoriesJSON.swift
//  EpicUS
//
//  Created by Denis Zubkov on 03/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct EpicUserStoriesJSON: Codable {
    let odataMetadata: String
    var value: [Value]
    
    enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    
    struct Value: Codable {
        let id, eusType, dataVersion, description, workDirectionId: String
        let dateCreate, dateRegistration, title, productOwnerId: String
        let dept, num, content: String
        let deletionMark: Bool
        var дополнительныеРеквизиты: [ДополнительныеРеквизиты]
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case eusType = "ВидДокумента_Key"
            case dataVersion = "DataVersion"
            case description = "Description"
            case workDirectionId = "ВопросДеятельности_Key"
            case dateCreate = "ДатаСоздания"
            case dateRegistration = "ДатаРегистрации"
            case title = "Заголовок"
            case productOwnerId = "Подготовил_Key"
            case dept = "Подразделение_Key"
            case num = "РегистрационныйНомер"
            case content = "Содержание"
            case deletionMark = "DeletionMark"
            case дополнительныеРеквизиты = "ДополнительныеРеквизиты"
        }
    }
    
    struct ДополнительныеРеквизиты: Codable {
        let id, lineNumber, parameterId: String
        var valueId, valueType, value: String
        
        
        enum CodingKeys: String, CodingKey {
            case id = "Ref_Key"
            case lineNumber = "LineNumber"
            case parameterId = "Свойство_Key"
            case valueId = "Значение"
            case valueType = "Значение_Type"
            case value = "ТекстоваяСтрока"
            
        }
    }
    
}
