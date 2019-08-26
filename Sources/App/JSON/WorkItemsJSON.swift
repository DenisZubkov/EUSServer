//
//  WorkItemsJSON.swift
//  EpicUS
//
//  Created by Denis Zubkov on 24/05/2019.
//  Copyright © 2019 TBM. All rights reserved.
//

import Foundation

struct WorkItemsJSON: Codable {
    let count: Int
    let value: [WorkItemJSON]
}


