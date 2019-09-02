//
//  ODataQuery.swift
//  EpicUS
//
//  Created by Denis Zubkov on 05/04/2019.
//  Copyright © 2019 TBM. All rights reserved.
//
import Foundation
import Routing
import Vapor

struct ODataQuery {
    var server: ODataServer
    var table: String
    var filter: String?
    var select: String?
    var orderBy: String?
    var id: Int?
}

enum QueryResultFormat: String {
    case json = "json"
    case xml = "xml"
    case tfs = "3.2"
}



