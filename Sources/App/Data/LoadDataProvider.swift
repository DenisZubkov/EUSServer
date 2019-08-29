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
    var products: [Product] = []
    var states: [State] = []
    var userStoryTypes: [UserStoryType] = []
    var userStories: [UserStory] = []
    var quarts: [Quart] = []
    
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
                UserDefaults.standard.set(data, forKey: "\(index)\(type.rawValue)")
                let _ = self.globalSettings.saveDataToFile(fileName: "\(index) \(type.rawValue)", fileExt: "json", data: data)
                index += 1
                if index < queries.count {
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
        let _ = UserStoryType.query(on: req).all().map { results in
            self.userStoryTypes = results
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
                                                            let _ = Quart.query(on: req).all().map { results in
                                                                self.quarts = results
                                                                let _ = EpicUserStory.query(on: req).all().map { results in
                                                                    self.epicUserStories = results
                                                                    let _ = TreeWorkItem.query(on: req).all().map { results in
                                                                        self.treeWorkItems = results
                                                                        let _ = Product.query(on: req).all().map { results in
                                                                            self.products = results
                                                                            let _ = State.query(on: req).all().map { results in
                                                                                self.states = results
                                                                                
                                                                                let _ = UserStory.query(on: req).all().map { results in
                                                                                    self.userStories = results
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
                        }
                    }
                }
            }
        }
    }
    
    func checkDBLoad(req: DatabaseConnectable) {
        let _ = UserStory.query(on: req).all().map { results in
            self.userStories = results
            print("UserStories: \(self.userStories.count)")
            let _ = Property.query(on: req).all().map { results in
                self.properties = results
                print("Properties: \(self.properties.count)")
                let _ = PropertyValue.query(on: req).all().map { results in
                    self.propertyValues = results
                    print("PropertyValues: \(self.propertyValues.count)")
                    let _ = StrategicTarget.query(on: req).all().map { results in
                        self.strategicTargets = results
                        print("StrategicTargets: \(self.strategicTargets.count)")
                        let _ = Tactic.query(on: req).all().map { results in
                            self.tactics = results
                            print("Tactics: \(self.tactics.count)")
                            let _ = Category.query(on: req).all().map { results in
                                self.categories = results
                                print("Categories: \(self.categories.count)")
                                let _ = BusinessValue.query(on: req).all().map { results in
                                    self.businessValues = results
                                    print("BusinessValues: \(self.businessValues.count)")
                                    let _ = Quart.query(on: req).all().map { results in
                                        self.quarts = results
                                        print("Quarts: \(self.quarts.count)")
                                        let _ = TypeTeam.query(on: req).all().map { results in
                                            self.typeTeams = results
                                            print("TypeTeams: \(self.typeTeams.count)")
                                            let _ = Dept.query(on: req).all().map { results in
                                                self.depts = results
                                                print("Depts: \(self.depts.count)")
                                                let _ = Team.query(on: req).all().map { results in
                                                    self.teams = results
                                                    print("Teams: \(self.teams.count)")
                                                    let _ = User.query(on: req).all().map { results in
                                                        self.users = results
                                                        print("Users: \(self.users.count)")
                                                        let _ = Direction.query(on: req).all().map { results in
                                                            self.directions = results
                                                            print("Directions: \(self.directions.count)")
                                                            let _ = Quota.query(on: req).all().map { results in
                                                                self.quotas = results
                                                                print("Quotas: \(self.quotas.count)")
                                                                let _ = EpicUserStory.query(on: req).all().map { results in
                                                                    self.epicUserStories = results
                                                                    print("EpicUserStories: \(self.epicUserStories.count)")
                                                                    let _ = TreeWorkItem.query(on: req).all().map { results in
                                                                        self.treeWorkItems = results
                                                                        print("TreeWorkItems: \(self.treeWorkItems.count)")
                                                                        let _ = Product.query(on: req).all().map { results in
                                                                            self.products = results
                                                                            print("Products: \(self.products.count)")
                                                                            let _ = State.query(on: req).all().map { results in
                                                                                self.states = results
                                                                                print("States: \(self.states.count)")
                                                                                let _ = UserStoryType.query(on: req).all().map { results in
                                                                                    self.userStoryTypes = results
                                                                                    print("UserStoryTypes: \(self.userStoryTypes.count)")
                                                                                    
                                                                                    self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
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
                        }
                    }
                }
            }
        }
    }
    
    func parceData(req: DatabaseConnectable) {
        self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
        parceUserStoryTypes(req: req)
        parceDataProvider.parceParameters(properties: &properties, req: req)
        parceDataProvider.parceParameterValues(propertyValues: &propertyValues, req: req)
        parceDataProvider.parceStrategicTargetsAndTactics(properties: properties, propertyValues: propertyValues, strategicTargets: &strategicTargets, tactics: &tactics, req: req)
        parceDataProvider.parceCategories(properties: properties, propertyValues: propertyValues, categories: &categories, req: req)
        parceDataProvider.parceQuarts(properties: properties, propertyValues: propertyValues, quarts: &quarts, req: req)
        parceDataProvider.parceBusinessValues(properties: properties, propertyValues: propertyValues, businessValues: &businessValues, req: req)
        parceDataProvider.parceTypeTeams(typeTeams: &typeTeams, req: req)
        parceDataProvider.parceDepts(depts: &depts, req: req)
        parceDataProvider.parceTeams(teams: &teams, req: req)
        parceDataProvider.parceUsers(users: &users, req: req)
        parceDataProvider.parceDirections(directions: &directions, req: req)
        parceDataProvider.parceQuotas(quotas: &quotas, req: req)
        parceDataProvider.parceEpicUserStories(directions: directions, categories: categories, tactics: tactics, users: users, quarts: quarts, businessValues: businessValues, states: &states, epicUserStories: &epicUserStories, req: req)
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
        let treeWorkItemsLevel = treeWorkItems.filter({$0.level == lev}).sorted(by:{$0.parentId < $1.parentId})
        var currentParentId = treeWorkItemsLevel[0].parentId
        var filterString: String? = nil
        if let tfsIdUpdate = tfsId {
            filterString = "\(tfsIdUpdate)"
        }
        for i in 0..<treeWorkItemsLevel.count {
            let tfsId = treeWorkItemsLevel[i].guid
            if currentParentId == treeWorkItemsLevel[i].parentId {
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
                currentParentId = treeWorkItemsLevel[i].parentId
                filterString = "\(tfsId)"
            }
            if i == treeWorkItemsLevel.count - 1 {
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
                    UserDefaults.standard.set(data, forKey: "\(id)\(type.rawValue)")
                }
                index += 1
                if index < queriesTFS.count {
                    self.getTreeWorkItemsJSONFromTFS(level: level, queriesTFS: queriesTFS, i: &index, type: type, req: req)
                } else {
                    
                    currentLevel += 1
                    self.parseTreeWorkItemsJSONFromTFS(level: currentLevel, queries: queriesTFS, req: req)
                    if currentLevel < 4 {
                        self.addTreeWorkItems(level: &currentLevel, req: req, tfsId: nil)
                        print("Level: \(currentLevel)")
                         self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
                    } else {
                        print("Product")
                        self.parceProducts(req: req)
                        self.updateEUSandUSFromTFS(req: req)
                        self.globalSettings.printDate(dateBegin: self.date, dateEnd: Date())
                        print("Check")
                        self.checkDBLoad(req: req)
//                        self.addEUSsFromTFSToCoreData(context: self.context)
                    }
                }
                
                
            }
        }
    }
    
   
    func parseTreeWorkItemsJSONFromTFS (level: Int, queries: [ODataQuery], req: DatabaseConnectable) {
        let type = QueryResultFormat.tfs
        for query in queries {
            if let id = query.id,
                let nsData = UserDefaults.standard.value(forKey: "\(id)\(type.rawValue)") as? NSData {
                let data = nsData as Data
                let results: WorkItemsJSON? = globalSettings.getType(from: data)
                if let workItems = results {
                    for workItem in workItems.value {
                        for strUrl in workItem.relations {
                            if strUrl.rel == "System.LinkTypes.Hierarchy-Forward",
                                let strId = strUrl.url.components(separatedBy: "/").last,
                                let id = Int(strId) {
                                
                                let treeWorkItemDB = TreeWorkItem.init(id: nil, guid: id, level: level, parentId: workItem.id)
                                let _ = treeWorkItemDB.save(on: req)
                                treeWorkItems.append(treeWorkItemDB)
                                
                            }
                        }
                    }
                }
                
            }
            
        }
    }
    
    func updateEUSandUSFromTFS (req: DatabaseConnectable) {
        let type = QueryResultFormat.tfs
        for index in 0..<epicUserStories.count {
            guard let tfsId = epicUserStories[index].tfsId else { continue }
            guard let parentId = treeWorkItems.filter({$0.guid == Int(tfsId)}).first?.parentId else { continue }
            guard let nsData = UserDefaults.standard.value(forKey: "\(parentId)\(type.rawValue)") as? NSData else { continue }
            let data = nsData as Data
            let results: WorkItemsJSON? = globalSettings.getType(from: data)
            guard let eusTFS = results?.value.filter({$0.id == Int(tfsId)}).first else { continue }
            epicUserStories[index].productId = String(parentId)
            epicUserStories[index].tfsAnalitic = eusTFS.fields.analiticName
            if epicUserStories[index].analiticId == nil || epicUserStories[index].analiticId == "",
                let analitic = eusTFS.fields.analiticName,
                let analiticId = users.filter({analitic.contains($0.fio)}).first?.guid {
                epicUserStories[index].analiticId = analiticId
            }
            epicUserStories[index].tfsBeginDate = globalSettings.convertStringTFSToDate(from: eusTFS.fields.beginDate)
            epicUserStories[index].tfsBusinessArea = eusTFS.fields.businessArea
            if let bussinessValue = eusTFS.fields.businessValue {
                epicUserStories[index].tfsBusinessValue = Int32(bussinessValue)
            }
            epicUserStories[index].tfsCategory = eusTFS.fields.categoryName
            epicUserStories[index].tfsDateCreate = globalSettings.convertStringTFSToDate(from: eusTFS.fields.createdDate)
            epicUserStories[index].tfsEndDate = globalSettings.convertStringTFSToDate(from: eusTFS.fields.endDate)
            epicUserStories[index].tfsLastChangeDate = globalSettings.convertStringTFSToDate(from: eusTFS.fields.lastChangeDate)
            epicUserStories[index].tfsParentWorkItemUrl = eusTFS.relations.filter({$0.rel == "System.LinkTypes.Hierarchy-Reverse"}).first?.url
            if let priority = eusTFS.fields.priority {
                epicUserStories[index].tfsPriority = Int32(priority)
            }
            epicUserStories[index].tfsProductOwner = eusTFS.fields.productOwner
            if let quart = eusTFS.fields.kvartal {
                epicUserStories[index].tfsQuart = Int32(quart)
            }
            epicUserStories[index].tfsState = eusTFS.fields.state
            epicUserStories[index].tfsStorePointAnaliticFact = eusTFS.fields.storePointsAnaliticFact
            epicUserStories[index].tfsStorePointAnaliticPlan = eusTFS.fields.storePointsAnaliticPlan
            epicUserStories[index].tfsStorePointDevFact = eusTFS.fields.storePointsDevFact
            epicUserStories[index].tfsStorePointDevPlan = eusTFS.fields.storePointsDevPlan
            epicUserStories[index].tfsStorePointFact = eusTFS.fields.storePointsFact
            epicUserStories[index].tfsStorePointPlan = eusTFS.fields.storePointsPlan
            epicUserStories[index].tfsTitle = eusTFS.fields.title
            epicUserStories[index].tfsWorkItemType = eusTFS.fields.workItemType
            if let stateId = states.filter({$0.name == eusTFS.fields.state!}).first?.guid {
                epicUserStories[index].stateId = stateId
            } else {
                epicUserStories[index].stateId = getState(name: eusTFS.fields.state!, req: req)
            }
            let _ = epicUserStories[index].save(on: req)
       }
    }
   
    func getState(name: String, req: DatabaseConnectable) -> String {
        let id = String(states.count)
        let stateDB = State.init(id: nil, guid: id, name: name)
        let _ = stateDB.save(on: req)
        states.append(stateDB)
        return(id)
    }
    
    
    
    func updateUSFromTFS(usTFS: WorkItemJSON, req: DatabaseConnectable) {
        
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
    
    //MARK: Products - update
    func parceProducts(req: DatabaseConnectable)  {
        products.removeAll()
        let _ = Product.query(on: req).delete()
        let tfsDirections = treeWorkItems.filter({$0.level == Int32(0)})
        let type = QueryResultFormat.tfs
        for tfsDirection in tfsDirections {
            if let nsData = UserDefaults.standard.value(forKey: "\(tfsDirection.guid)\(type.rawValue)") as? NSData,
                let directionId = self.directions.filter({$0.tfsId == tfsDirection.guid}).first?.guid{
                let data = nsData as Data
                let result: WorkItemsJSON? = globalSettings.getType(from: data)
                if let workItems = result?.value {
                    for workItem in workItems {
                        if let state = workItem.fields.state,
                            state == "Новый",
                            let productOwner = workItem.fields.productOwner,
                            let productOwnerId = users.filter({productOwner.contains($0.fio)}).first?.guid {
                            let productDB = Product.init(id: nil, guid: "\(workItem.id)", dataVersion: "\(workItem.rev)", name: workItem.fields.title ?? "" , tfsId: workItem.id, productOwnerId: productOwnerId, directionId: directionId)
                            let _ = productDB.save(on: req)
                            products.append(productDB)
                            
                        }
                    }
                }
                
            }
        }
    }
    
    //MARK: UserStoryTypes - update
    func parceUserStoryTypes(req: DatabaseConnectable) {
        userStoryTypes.removeAll()
        let _ = UserStoryType.query(on: req).delete()
        var userStoryType = UserStoryType.init(id: nil, guid: "[ANLZ", name: "Анализ", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[ANLZ", name: "Анализ", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[ANLZ", name: "Анализ", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[DCMP", name: "Декомпозиция", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[WORK", name: "Выполнение", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[TEST", name: "Тестирование", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[ТЕСТ", name: "Тестирование", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[STOP", name: "Остановлено ВП", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[WAIT", name: "Ожидание", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[DOC",  name: "Документация", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[VND",  name: "Внедрение", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[VP",   name: "Ожидание ВП", type: "analitic")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[K",    name: "Разработка", type: "developer")
        userStoryTypes.append(userStoryType)
        userStoryType = UserStoryType.init(id: nil, guid: "[ERR",  name: "Ошибка", type: "developer")
        userStoryTypes.append(userStoryType)
        for i in userStoryTypes {
            let _ = i.save(on: req)
        }
    }
    
}
