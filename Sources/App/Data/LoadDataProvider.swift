//
//  LoadDataProvider.swift
//  App
//
//  Created by Denis Zubkov on 06/08/2019.
//

import Foundation
import Routing
import Vapor

class LoadDataProvider {
    
    var queriesTFS: [ODataQuery] = []
    let dataProvider = DataProvider()
    let globalSettings = GlobalSettings()
    let parceDataProvider = ParceDataProvider()
    var date = Date()
    var properties: [Property] = []
    var propertyValues: [PropertyValue] = []
    var strategicTargets: [StrategicTarget] = []
    var tactics: [Tactic] = []
    var categories: [Category] = []
    var businessValues: [BusinessValue] = []
    var typeTeams: [TypeTeam] = []
    var depts: [Dept] = []
    var teams: [Team] = []
    var users: [User] = []
    var directions: [Direction] = []
    var quotas: [Quota] = []
    var epicUserStories: [EpicUserStory] = []
    var treeWorkItems: [TreeWorkItem] = []
    
    func getAllData(req: DatabaseConnectable) {
        let queries = globalSettings.prepareQueryArray()
        var index = 0
        getDataFrom(queries: queries, i: &index, type: .json, req: req)
    }
    
    
    
    func getDataFrom(queries: [ODataQuery], i: inout Int, type: QueryResultFormat, req: DatabaseConnectable) {
        var urlComponents = dataProvider.getUrlComponents(server: queries[i].server, query: queries[i], format: type)
        urlComponents.user = globalSettings.login
        urlComponents.password = globalSettings.password
        guard let url = urlComponents.url else { return }
        var index = i
        self.dataProvider.downloadDataNTLM(url: url) { data in
            if let data = data {
                UserDefaults.standard.set(data, forKey: "\(index)")
                let _ = self.globalSettings.saveDataToFile(fileName: "\(index) \(type)", fileExt: "json", data: data)
                print(data)
                index += 1
                if index < 1  { //queries.count {
                    self.getDataFrom(queries: queries, i: &index, type: type, req: req)
                    self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
                    
                } else {
                    self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
                    self.getDataFromDB(req: req)
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    func getDataFromDB(req: DatabaseConnectable) {
        let _ = Property.query(on: req).all().map { results in
            self.properties = results
            let _ = PropertyValue.query(on: req).all().map { results in
                self.propertyValues = results
                let _ = StrategicTarget.query(on: req).all().map { results in
                    self.strategicTargets = results
                    let _ = Tactic.query(on: req).all().map { results in
                        self.tactics = results
                        let _ = Category.query(on: req).all().map { results in
                            self.categories = results
                            let _ = BusinessValue.query(on: req).all().map { results in
                                self.businessValues = results
                                let _ = TypeTeam.query(on: req).all().map { results in
                                    self.typeTeams = results
                                    let _ = Dept.query(on: req).all().map { results in
                                        self.depts = results
                                        let _ = Team.query(on: req).all().map { results in
                                            self.teams = results
                                            let _ = User.query(on: req).all().map { results in
                                                self.users = results
                                                let _ = Direction.query(on: req).all().map { results in
                                                    self.directions = results
                                                    let _ = Quota.query(on: req).all().map { results in
                                                        self.quotas = results
                                                        let _ = EpicUserStory.query(on: req).all().map { results in
                                                            self.epicUserStories = results
                                                            self.parceData(req: req)
                                                            self.getTreeWorkItems(req: req)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func parceData(req: DatabaseConnectable) {
        self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
        parceDataProvider.parceParameters(properties: &properties, req: req)
        parceDataProvider.parceParameterValues(propertyValues: &propertyValues, req: req)
        parceDataProvider.parceStrategicTargetsAndTactics(properties: properties, propertyValues: propertyValues, strategicTargets: &strategicTargets, tactics: &tactics, req: req)
        parceDataProvider.parceCategories(properties: properties, propertyValues: propertyValues, categories: &categories, req: req)
        parceDataProvider.parceBusinessValues(properties: properties, propertyValues: propertyValues, businessValues: &businessValues, req: req)
        parceDataProvider.parceTypeTeams(typeTeams: &typeTeams, req: req)
        parceDataProvider.parceDepts(depts: &depts, req: req)
        parceDataProvider.parceTeams(teams: &teams, req: req)
        parceDataProvider.parceUsers(users: &users, req: req)
        parceDataProvider.parceDirections(directions: &directions, req: req)
        parceDataProvider.parceQuotas(quotas: &quotas, req: req)
        parceDataProvider.parceEpicUserStories(directions: directions, categories: categories, tactics: tactics, businessValues: businessValues, epicUserStories: &epicUserStories, req: req)
        self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
    }
    
    
    func getTFSData(req: DatabaseConnectable) {
        getTreeWorkItems(req: req)
    }
    
    func getTreeWorkItems(req: DatabaseConnectable) {
        
        // удаляем дерево
        treeWorkItems.removeAll()
        let _ = TreeWorkItem.query(on: req).delete()
        
        // добавляем направления как корневые WorkItems
        for direction in directions {
            let treeWorkItem = TreeWorkItem.init(id: nil, guid: Int(direction.tfsId), level: 0, parentId: 0)
            treeWorkItems.append(treeWorkItem)
            let _ = treeWorkItem.create(on: req)
        }
        var level = 0
        self.addTreeWorkItems(level: &level, req: req, tfsId: nil)
    }
    
    
    
    
    func addTreeWorkItems(level: inout Int, req: DatabaseConnectable, tfsId: Int32?) {
        queriesTFS.removeAll()
        let lev = level
        let _ = TreeWorkItem.query(on: req).all().map { results in
            let treeWorkItems = results.filter({$0.level == lev}).sorted(by:{$0.parentId < $1.parentId})
            var currentParentId = results[0].parentId
            var filterString: String? = nil
            if let tfsIdUpdate = tfsId {
                filterString = "\(tfsIdUpdate)"
            }
            for i in 0..<treeWorkItems.count {
                let tfsId = results[i].guid
                if currentParentId == results[i].parentId {
                    if filterString == nil {
                        filterString = "\(tfsId)"
                    } else {
                        filterString = "\(filterString!), \(tfsId)"
                    }
                } else {
                    let query = ODataQuery.init(server: self.globalSettings.serverTFS,
                                                table: "workitems",
                                                filter: filterString,
                                                select: nil,
                                                orderBy: nil,
                                                id: currentParentId)
                    self.queriesTFS.append(query)
                    currentParentId = results[i].parentId
                    filterString = "\(tfsId)"
                }
                if i == results.count - 1 {
                    let query = ODataQuery.init(server: self.globalSettings.serverTFS,
                                                table: "workitems",
                                                filter: filterString,
                                                select: nil,
                                                orderBy: nil,
                                                id: currentParentId)
                    self.queriesTFS.append(query)
                }
                
            }
            var index = 0
            if tfsId == nil {
                self.getTreeWorkItemsJSONFromTFS(level: lev, queriesTFS: self.queriesTFS, i: &index, type: .tfs, req: req)
            } else {
                self.getUpdatedWorkItemsFromTFS(queryTFS: self.queriesTFS[0], tfsIdMain: tfsId!, req: req)
            }
            
        }
    }
    
    func getUpdatedWorkItemsFromTFS(queryTFS: ODataQuery, tfsIdMain: Int32, req: DatabaseConnectable) {
        var urlComponents = self.dataProvider.getUrlComponents(server: queryTFS.server, query: queryTFS, format: .tfs)
        urlComponents.user = globalSettings.login
        urlComponents.password = globalSettings.password
        guard let newPriority = epicUserStories.filter({$0.tfsId == tfsIdMain }).first?.tfsPriority else { return }
        guard let url = urlComponents.url else { return }
        self.dataProvider.downloadDataFromTFS(url: url) { data in
            
            if let data = data {
                let results: WorkItemsJSON? = self.globalSettings.getType(from: data)
                if let workItems = results {
                    for workItem in workItems.value {
                        let rev = workItem.rev
                        self.dataProvider.patchPriority(server: queryTFS.server, rev: rev, workItem: workItem.id, priority: Int(newPriority)) {
                            data in
                        }
                        
                    }
                }
            }
        }
    }
    
    
    func getTreeWorkItemsJSONFromTFS(level: Int, queriesTFS: [ODataQuery], i: inout Int, type: QueryResultFormat, req: DatabaseConnectable) {
        var urlComponents = self.dataProvider.getUrlComponents(server: queriesTFS[i].server, query: queriesTFS[i], format: type)
        urlComponents.user = globalSettings.login
        urlComponents.password = globalSettings.password
        guard let url = urlComponents.url else { return }
        var index = i
        var currentLevel = level
        self.dataProvider.downloadDataNTLM(url: url) { data in
            if let data = data {
                if let id = queriesTFS[index].id {
                    UserDefaults.standard.set(data, forKey: "\(id)")
                }
                index += 1
                if index < queriesTFS.count {
                    self.getTreeWorkItemsJSONFromTFS(level: level, queriesTFS: queriesTFS, i: &index, type: type, req: req)
                } else {
                    self.parceDataProvider.parseTreeWorkItemsJSONFromTFS(level: level, queries: queriesTFS, req: req, treeWorkitems: &self.treeWorkItems)
                    //self.treeWorkItems = self.loadArrayFromCoreData(object: "TreeWorkItem", context: self.context)
                    //                    for treeWorkItem in self.treeWorkItems {
                    //                        print("\(treeWorkItem.level) \(treeWorkItem.parentId) \(treeWorkItem.id)")
                    //                    }
                    //                    print(self.treeWorkItems.count)
                    currentLevel += 1
                    if currentLevel < 4 {
                        self.addTreeWorkItems(level: &currentLevel, req: req, tfsId: nil)
                        print("Level: \(currentLevel)")
                         self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
                    } else {
                         print("End")
                         self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
//                        self.addProductsToCoreData(context: self.context)
//                        self.addEUSsFromTFSToCoreData(context: self.context)
                    }
                }
                
                
            }
        }
    }
   
    
    
}
