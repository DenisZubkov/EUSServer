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
    
    var usersTeams: [String:String] = [:]
    let type = QueryResultFormat.json
    var dataDict: [String : Data] = [:]
    var flag: String = "Началось"
    
    
    func TestConnectAPI(req: DatabaseConnectable) -> String {
        let filterParameters = globalSettings.createOrFilter(fieldName: "Ref_Key", valueDict: globalSettings.parameterDict)
        let query = ODataQuery.init(server: self.globalSettings.serverTFS,
                                    table: "workitems",
                                    filter: "4644, 4642,5547, 4641, 4637, 4640, 5548, 4638, 4639, 4643",
                                    select: nil,
                                    orderBy: nil,
                                    id: 3717)
        var urlComponents = dataProvider.getUrlComponents(server: query.server, query: query, format: .tfs)
        urlComponents.user = globalSettings.login
        urlComponents.password = globalSettings.password
        flag = "Begin..."
        
        //guard let url = urlComponents.url else { return "Bad url" }
        guard let url = URL(string: "http://zubkoff:!den20zu10@tfs1.tbm.ru:8080/tfs/DefaultCollection/_apis/wit/workitems?ids=4644,4642&$expand=relations&api-version=3.2") else { return "Bad url" }
        do {
            let data = try Data(contentsOf: url)
            flag = String.init(data: data, encoding: .utf8)!
        } catch let error as NSError {
            print(error.localizedDescription)
            flag = error.localizedDescription
        }
//        self.dataProvider.downloadDataNTLM(url: url) { data in
//            guard let data = data else {
//                self.flag = "Данных не получено"
//                return
//            }
//
//            return
//        }
        
//        while flag == "Begin..." {
//            
//        }
        return flag
    }
        
    
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
                self.dataDict["\(index)\(type.rawValue)"] = data
                let _ = self.globalSettings.saveDataToFile(fileName: "\(index) \(type.rawValue)", fileExt: "json", data: data)
                self.globalSettings.saveLoadLog(date: Date(), name: "Загрузка данных из 1С", description: type.rawValue, value: index, time: nil, req: req)
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
        self.globalSettings.saveLoadLog(date: Date(), name: "Загрузка данных из DB", description: nil, value: nil, time: nil, req: req)
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
                                                                                    self.globalSettings.saveLoadLog(date: Date(), name: "Разбор данных", description: nil, value: nil, time: nil, req: req)
                                                                                    self.parceData(req: req)
                                                                                    self.globalSettings.saveLoadLog(date: Date(), name: "Загрузка данных из TFS", description: nil, value: nil, time: nil, req: req)
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
        parceParameters(req: req)
        parceParameterValues(req: req)
        parceStrategicTargetsAndTactics(req: req)
        parceCategories(req: req)
        parceQuarts(req: req)
        parceBusinessValues(req: req)
        parceTypeTeams(req: req)
        parceDepts(req: req)
        parceTeams(req: req)
        parceUsers(req: req)
        parceDirections(req: req)
        parceQuotas(req: req)
        parceEpicUserStories(req: req)
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
        //print(url.absoluteString)
        var index = i
        var currentLevel = level
        self.dataProvider.downloadDataNTLM(url: url) { data in
            if let data = data {
                if let id = queriesTFS[index].id {
                    self.dataDict["\(id)\(type.rawValue)"] = data
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
                let data = dataDict["\(id)\(type.rawValue)"] {
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
            guard let data = dataDict["\(parentId)\(type.rawValue)"] else { continue }
            let results: WorkItemsJSON? = globalSettings.getType(from: data)
            guard let eusTFS = results?.value.filter({$0.id == Int(tfsId)}).first else { continue }
            epicUserStories[index].productId = String(parentId)
            epicUserStories[index].tfsAnalitic = eusTFS.fields.analiticName
            if epicUserStories[index].analiticId == nil || epicUserStories[index].analiticId == "",
                let analitic = eusTFS.fields.analiticName,
                let analiticId = users.filter({analitic.contains($0.fio)}).first?.guid {
                epicUserStories[index].analiticId = analiticId
            }
            epicUserStories[index].tfsBeginDate = eusTFS.fields.beginDate
            epicUserStories[index].tfsBusinessArea = eusTFS.fields.businessArea
            if let bussinessValue = eusTFS.fields.businessValue {
                epicUserStories[index].tfsBusinessValue = Int32(bussinessValue)
            }
            epicUserStories[index].tfsCategory = eusTFS.fields.categoryName
            epicUserStories[index].tfsDateCreate = eusTFS.fields.createdDate
            epicUserStories[index].tfsEndDate = eusTFS.fields.endDate
            epicUserStories[index].tfsLastChangeDate = eusTFS.fields.lastChangeDate
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
            if let data = dataDict["\(tfsDirection.guid)\(type.rawValue)"],
                let directionId = self.directions.filter({$0.tfsId == tfsDirection.guid}).first?.guid{
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
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: 1C - PARSING
    
    //MARK: Parameters - update
    func parceParameters(req: DatabaseConnectable)  {
        if let data = dataDict["0\(type.rawValue)"] {
            let parametersJSON: ParametersJSON? = self.globalSettings.getType(from: data)
            if let parameters = parametersJSON?.value {
                for parameter in parameters {
                    if var property = properties.filter({$0.guid == parameter.id}).first {
                        if property.dataVersion != parameter.dataVersion {
                            property.dataVersion = parameter.dataVersion
                            property.name = parameter.name
                            let _ = property.save(on: req)
                        }
                    } else {
                        let property = Property.init(id: nil, guid: parameter.id, dataVersion: parameter.dataVersion, name: parameter.name)
                        let _ = property.save(on: req)
                        properties.append(property)
                    }
                    
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: PropertyValues - update
    func parceParameterValues(req: DatabaseConnectable)  {
        if let data = dataDict["1\(type.rawValue)"] {
            let parameterValuesJSON: ParameterValuesJSON? = self.globalSettings.getType(from: data)
            if let parameterValues = parameterValuesJSON?.value {
                for parameterValue in parameterValues {
                    if var propertyValue = propertyValues.filter({$0.guid == parameterValue.id}).first {
                        if propertyValue.dataVersion != parameterValue.dataVersion {
                            propertyValue.dataVersion = parameterValue.dataVersion
                            propertyValue.isFolder = parameterValue.isFolder
                            propertyValue.parentId = parameterValue.parentId
                            propertyValue.propertyId = parameterValue.parameterId
                            propertyValue.value = parameterValue.value
                            let _ = propertyValue.save(on: req)
                        }
                    } else {
                        let propertyValue = PropertyValue.init(id: nil, guid: parameterValue.id, isFolder: parameterValue.isFolder, dataVersion: parameterValue.dataVersion, parentId: parameterValue.parentId, propertyId: parameterValue.parameterId, value: parameterValue.value)
                        let _ = propertyValue.save(on: req)
                        propertyValues.append(propertyValue)
                    }
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: StrategicTargets, Tactics - update
    func parceStrategicTargetsAndTactics(req: DatabaseConnectable)  {
        
        if let tacticId = properties.filter({$0.name == "Тактика"}).first?.guid {
            let strategicTargets1C = propertyValues.filter({$0.propertyId == tacticId})
            for strategicTarget1C in strategicTargets1C {
                if (strategicTarget1C.isFolder) {
                    if var strategicTargetDB = strategicTargets.filter({$0.guid == strategicTarget1C.guid}).first {
                        if strategicTargetDB.dataVersion != strategicTarget1C.dataVersion {
                            strategicTargetDB.dataVersion = strategicTarget1C.dataVersion
                            strategicTargetDB.name = strategicTarget1C.value
                            let _ = strategicTargetDB.save(on: req)
                        }
                    } else {
                        let strategicTargetDB = StrategicTarget.init(id: nil, guid: strategicTarget1C.guid, dataVersion: strategicTarget1C.dataVersion, name: strategicTarget1C.value)
                        let _ = strategicTargetDB.save(on: req)
                        strategicTargets.append(strategicTargetDB)
                    }
                } else {
                    if var tacticDB = tactics.filter({$0.guid == strategicTarget1C.guid}).first {
                        if tacticDB.dataVersion != strategicTarget1C.dataVersion {
                            tacticDB.dataVersion = strategicTarget1C.dataVersion
                            tacticDB.name = strategicTarget1C.value
                            tacticDB.strategicTargetId = strategicTarget1C.parentId
                            let _ = tacticDB.save(on: req)
                        }
                    } else {
                        let tacticDB = Tactic.init(id: nil, guid: strategicTarget1C.guid, dataVersion: strategicTarget1C.dataVersion, strategicTargetId: strategicTarget1C.parentId, name: strategicTarget1C.value)
                        let _ = tacticDB.save(on: req)
                        tactics.append(tacticDB)
                    }
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    
    //MARK: Categories - update
    func parceCategories(req: DatabaseConnectable)  {
        
        if let categoryId = properties.filter({$0.name == "Категория"}).first?.guid {
            let categories1C = propertyValues.filter({$0.propertyId == categoryId})
            for category1C in categories1C {
                var shortName = ""
                switch category1C.value {
                case "Клиенты":
                    shortName = "К"
                case "Поставщики":
                    shortName = "П"
                case "Государство":
                    shortName = "Г"
                case "Сотрудники":
                    shortName = "С"
                default:
                    shortName = ""
                }
                if var categoryDB = categories.filter({$0.guid == categoryId}).first {
                    if categoryDB.dataVersion != category1C.dataVersion {
                        categoryDB.dataVersion = category1C.dataVersion
                        categoryDB.name = category1C.value
                        categoryDB.short = shortName
                        let _ = categoryDB.save(on: req)
                    }
                } else {
                    let categoryDB = Category.init(id: nil, guid: category1C.guid, dataVersion: category1C.dataVersion, name: category1C.value, short: shortName)
                    let _ = categoryDB.save(on: req)
                    categories.append(categoryDB)
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    
    
    //MARK: BusinessValues - update
    func parceBusinessValues(req: DatabaseConnectable)  {
        
        if let businessValueId = properties.filter({$0.name == "Ценность"}).first?.guid {
            let businessValues1C = propertyValues.filter({$0.propertyId == businessValueId})
            for businessValue1C in businessValues1C {
                if var businessValueDB = businessValues.filter({$0.guid == businessValueId}).first {
                    if businessValueDB.dataVersion != businessValue1C.dataVersion {
                        businessValueDB.dataVersion = businessValue1C.dataVersion
                        businessValueDB.name = businessValue1C.value
                        businessValueDB.value = globalSettings.getBusinessValueInt(value: businessValue1C.value)
                        businessValueDB.days = globalSettings.getBusinessValueDays(value: businessValue1C.value)
                        let _ = businessValueDB.save(on: req)
                    }
                } else {
                    let businessValueDB = BusinessValue.init(id: nil, guid: businessValue1C.guid, dataVersion: businessValue1C.dataVersion, name: businessValue1C.value, value: globalSettings.getBusinessValueInt(value: businessValue1C.value), days: globalSettings.getBusinessValueDays(value: businessValue1C.value))
                    let _ = businessValueDB.save(on: req)
                    businessValues.append(businessValueDB)
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: Quarts - update
    func parceQuarts(req: DatabaseConnectable)  {
        
        if let quartId = properties.filter({$0.name == "Квартал"}).first?.guid {
            let quarts1C = propertyValues.filter({$0.propertyId == quartId})
            for quart1C in quarts1C {
                if var quartDB = quarts.filter({$0.guid == quartId}).first {
                    if quartDB.dataVersion != quart1C.dataVersion {
                        quartDB.dataVersion = quart1C.dataVersion
                        quartDB.name = quart1C.value
                        let _ = quartDB.save(on: req)
                    }
                } else {
                    let quartDB = Quart.init(id: nil, guid: quart1C.guid, dataVersion: quart1C.dataVersion, name: quart1C.value)
                    let _ = quartDB.save(on: req)
                    quarts.append(quartDB)
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: TypeTeams - update
    func parceTypeTeams(req: DatabaseConnectable)  {
        for index in 0..<4 {
            if var typeTeamDB = typeTeams.filter({$0.guid == String(index)}).first {
                if typeTeamDB.dataVersion != String(index) {
                    typeTeamDB.dataVersion = String(index)
                    typeTeamDB.name = globalSettings.typeTeamList[index].rawValue
                    let _ = typeTeamDB.save(on: req)
                }
            } else {
                let typeTeamDB = TypeTeam.init(id: nil, guid: String(index), dataVersion: String(index), name: globalSettings.typeTeamList[index].rawValue)
                let _ = typeTeamDB.save(on: req)
                typeTeams.append(typeTeamDB)
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    
    
    // MARK: Dept - update
    func parceDepts(req: DatabaseConnectable)  {
       if let data = dataDict["2\(type.rawValue)"] {
            let deptsJSON: DeptsJSON? = self.globalSettings.getType(from: data)
            
            if let depts1C = deptsJSON?.value {
                for dept1C in depts1C {
                    var oracleId = ""
                    if let oracle = dept1C.дополнительныеРеквизиты.first {
                        oracleId = oracle.value
                    }
                    if var deptDB = depts.filter({$0.guid == dept1C.id}).first {
                        if deptDB.dataVersion != dept1C.dataVersion {
                            deptDB.dataVersion = dept1C.dataVersion
                            deptDB.parentId = dept1C.parentId
                            deptDB.headId = dept1C.headId
                            deptDB.oracleId = oracleId
                            deptDB.name = dept1C.description
                            let _ = deptDB.save(on: req)
                        }
                    } else {
                        let deptDB = Dept.init(id: nil, guid: dept1C.id, dataVersion: dept1C.dataVersion, parentId: dept1C.parentId, headId: dept1C.headId, oracleId: oracleId, name: dept1C.description)
                        let _ = deptDB.save(on: req)
                        depts.append(deptDB)
                    }
                    
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    // MARK: Teams - update
    func parceTeams(req: DatabaseConnectable)  {
       if let data = dataDict["3\(type.rawValue)"] {
            let userGroupsJSON: UserGroupsJSON? = self.globalSettings.getType(from: data)
            
            if let teams1C = userGroupsJSON?.value {
                for team1C in teams1C {
                    let firstSymbol = team1C.description[team1C.description.startIndex]
                    var typeTeamId = "1"
                    switch firstSymbol {
                    case "K", "К":
                        typeTeamId = "1"
                    case "A", "А":
                        typeTeamId = "0"
                    case "В", "B":
                        typeTeamId = "2"
                    case "P", "Р":
                        typeTeamId = "3"
                    default:
                        typeTeamId = "1"
                    }
                    if var teamDB = teams.filter({$0.guid == team1C.id}).first {
                        if teamDB.dataVersion != team1C.dataVersion {
                            teamDB.dataVersion = team1C.dataVersion
                            teamDB.name = team1C.description
                            teamDB.typeTeamId = typeTeamId
                            
                            let _ = teamDB.save(on: req)
                        }
                    } else {
                        let teamDB = Team.init(id: nil, guid: team1C.id, dataVersion: team1C.dataVersion, name: team1C.description, typeTeamId: typeTeamId)
                        let _ = teamDB.save(on: req)
                        teams.append(teamDB)
                    }
                    for user in team1C.content {
                        usersTeams[user.userId] = team1C.id
                    }
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    // MARK: Users - update
    func parceUsers(req: DatabaseConnectable)  {
        if let data = dataDict["4\(type.rawValue)"] {
            let usersJSON: UsersJSON? = self.globalSettings.getType(from: data)
            
            if let users1C = usersJSON?.value {
                for user1C in users1C {
                    if let teamId = usersTeams[user1C.id] {
                        if var userDB = users.filter({$0.guid == user1C.id}).first {
                            if userDB.dataVersion != user1C.dataVersion {
                                userDB.dataVersion = user1C.dataVersion
                                userDB.fio = user1C.description
                                if let email = user1C.контактнаяИнформация.filter({$0.lineNumber == "1"}).first {
                                    userDB.email = email.value
                                }
                                if let phone = user1C.контактнаяИнформация.filter({$0.lineNumber == "2"}).first {
                                    userDB.phone = phone.value
                                }
                                if let oracleId = user1C.дополнительныеРеквизиты.first?.value {
                                    userDB.oracleId = oracleId
                                }
                                userDB.deptId = user1C.deptId
                                userDB.teamId = teamId
                                let _ = userDB.save(on: req)
                            }
                        } else {
                            var userDB = User.init(id: nil, guid: user1C.id, dataVersion: user1C.dataVersion, fio: user1C.description, email: "", oracleId: "", phone: "", deptId: user1C.deptId, teamId: teamId, headId: "")
                            if let email = user1C.контактнаяИнформация.filter({$0.lineNumber == "1"}).first {
                                userDB.email = email.value
                            }
                            if let phone = user1C.контактнаяИнформация.filter({$0.lineNumber == "2"}).first {
                                userDB.phone = phone.value
                            }
                            if let oracleId = user1C.дополнительныеРеквизиты.first?.value {
                                userDB.oracleId = oracleId
                            }
                            let _ = userDB.save(on: req)
                            users.append(userDB)
                            
                        }
                    }
                    
                    
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    
    //MARK: Directions - update
    func parceDirections(req: DatabaseConnectable)  {
        if let data = dataDict["6\(type.rawValue)"] {
            let directionsJSON: DirectionsJSON? = self.globalSettings.getType(from: data)
            
            if let directions1C = directionsJSON?.value {
                for direction1C in directions1C {
                    let tfsId =  globalSettings.tfsDirectionDict[direction1C.id] ?? 0
                    let ord = Int32(direction1C.ord) ?? 0
                    if var directionDB = directions.filter({$0.guid == direction1C.id}).first {
                        if directionDB.dataVersion != direction1C.dataVersion {
                            directionDB.dataVersion = direction1C.dataVersion
                            directionDB.name = direction1C.name
                            directionDB.small = direction1C.shortName
                            directionDB.headId = direction1C.userId
                            directionDB.ord = ord
                            directionDB.tfsId = tfsId
                            let _ = directionDB.save(on: req)
                        }
                    } else {
                        let directionDB = Direction.init(id: nil, guid: direction1C.id, dataVersion: direction1C.dataVersion, name: direction1C.name, ord: ord, small: direction1C.shortName, tfsId: tfsId, headId: direction1C.userId)
                        let _ = directionDB.save(on: req)
                        directions.append(directionDB)
                    }
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: Quotas - update
    func parceQuotas(req: DatabaseConnectable)  {
        if let data = dataDict["7\(type.rawValue)"] {
            let quotasJSON: QuotasJSON? = self.globalSettings.getType(from: data)
            
            if let quotas1C = quotasJSON?.value {
                for quota1C in quotas1C {
                    let date = quota1C.quart
                    if var quotaDB = quotas.filter({$0.quart == date && $0.directionId == quota1C.directionId}).first {
                        quotaDB.storePointAnaliticPlan = quota1C.storePointAnaliticPlan
                        quotaDB.storePointAnaliticFact = quota1C.storePointAnaliticFact
                        quotaDB.storePointAnaliticWork = quota1C.storePointAnaliticWork
                        quotaDB.storePointDevPlan = quota1C.storePointDevPlan
                        quotaDB.storePointDevFact = quota1C.storePointDevFact
                        quotaDB.storePointDevWork = quota1C.storePointDevWork
                        let _ = quotaDB.save(on: req)
                    } else {
                        let quotaDB = Quota.init(id: nil, quart: date, storePointAnaliticPlan: quota1C.storePointAnaliticPlan, storePointAnaliticFact: quota1C.storePointAnaliticFact, storePointAnaliticWork: quota1C.storePointAnaliticWork, storePointDevPlan: quota1C.storePointDevPlan, storePointDevFact: quota1C.storePointDevFact, storePointDevWork: quota1C.storePointDevWork, directionId: quota1C.directionId)
                        let _ = quotaDB.save(on: req)
                        quotas.append(quotaDB)
                    }
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    //MARK: EpicUserStories - update
    func parceEpicUserStories(req: DatabaseConnectable)  {
        if let data = dataDict["5\(type.rawValue)"],
           let stateData = dataDict["8\(type.rawValue)"] {
            let epicUserStoriesJSON: EpicUserStoriesJSON? = self.globalSettings.getType(from: data)
            let eusStateJSON: EUSStateJSON? = self.globalSettings.getType(from: stateData)
            
            if let eus1C = epicUserStoriesJSON?.value {
                for eus1C in eus1C {
                    if eus1C.eusType == globalSettings.eusTypeDict[.eus18] {
                        if let tfsUrl = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.eusUrl18]}).first {
                            if tfsUrl.valueId.hasPrefix("http://tfs:8080/tfs/DIT/MAIN-BACKLOG") {
                                continue
                            }
                        } else {
                            continue
                        }
                        if let stage = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.visa]}).first {
                            if stage.valueId == "6dd39d53-bad8-11e7-acc5-0050568d26bf" ||  stage.valueId == "73d55f9d-bad8-11e7-acc5-0050568d26bf" {
                                continue
                            }
                        } else {
                            continue
                        }
                    }
                    var directionId = ""
                    if let directionNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.direction19]}).first {
                        if let direction = directions.filter({$0.guid == directionNew.valueId}).first {
                            directionId = direction.guid
                        }
                    }
                    if let directionNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.direction18]}).first {
                        if let direction = directions.filter({$0.guid == directionNew.valueId}).first {
                            directionId = direction.guid
                        }
                    }
                    var categoryId = ""
                    if let categoryNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.category]}).first {
                        if let category = categories.filter({$0.guid == categoryNew.valueId}).first {
                            categoryId = category.guid
                        }
                    }
                    var tacticId = ""
                    if let tacticNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.tactic]}).first {
                        if let tactic = tactics.filter({$0.guid == tacticNew.valueId}).first {
                            tacticId = tactic.guid
                        }
                    }
                    var analiticId = ""
                    if let analiticNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.analitic]}).first {
                        if let analitic = users.filter({$0.guid == analiticNew.valueId}).first {
                            analiticId = analitic.guid
                        }
                    }
                    var businessValueId = ""
                    if let valueNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.businessValue19]}).first {
                        if let valueB = businessValues.filter({$0.guid == valueNew.valueId}).first {
                            businessValueId = valueB.guid
                        }
                    }
                    if let valueNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.businessValue18]}).first {
                        if let valueB = businessValues.filter({$0.guid == valueNew.valueId}).first {
                            businessValueId = valueB.guid
                        }
                    }
                    var storePointsAnaliticPlane = ""
                    if let storePointAnaliticNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.storePointsAnaliticPlan]}).first {
                        storePointsAnaliticPlane = storePointAnaliticNew.valueId
                        let storePointAnaliticNewArray = Array(storePointAnaliticNew.valueId)
                        var storePoint: String = ""
                        var inBounds = false
                        for i in (0..<storePointAnaliticNewArray.count) {
                            if storePointAnaliticNewArray[i] == "(" {
                                inBounds = true
                            } else {
                                if storePointAnaliticNewArray[i] == ")" {
                                    inBounds = false
                                }
                                if inBounds {
                                    storePoint = storePoint + String(storePointAnaliticNewArray[i])
                                }
                            }
                        }
                        if storePoint.count > 0 {
                            storePointsAnaliticPlane = storePoint
                        }
                        
                    }
                    var storePointsDevPlane = ""
                    if let storePointDeveloperNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.storePointsDevPlan]}).first {
                        storePointsDevPlane = storePointDeveloperNew.valueId
                    }
                    var tfsIdDB: Int32 = 0
                    var tfsUrlDB = ""
                    if let tfsUrl = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.eusUrl19]}).first {
                        tfsUrlDB = tfsUrl.valueId
                        let tfsUrlArray = Array(tfsUrl.valueId)
                        var tfsId: String = ""
                        for i in (0..<tfsUrlArray.count).reversed() {
                            if tfsUrlArray[i] != "/" {
                                tfsId = String(tfsUrlArray[i]) + tfsId
                            } else {
                                break
                            }
                        }
                        if tfsId.count > 10,
                            let last = tfsId.components(separatedBy: "_workitems?id=").last,
                            let first = last.components(separatedBy: "&_a=edit").first {
                            tfsId = first
                            
                            
                        }
                        if let tfsId = Int32(tfsId) {
                            tfsIdDB = tfsId
                            
                        }
                    }
                    
                    if let tfsUrl = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.eusUrl18]}).first {
                        tfsUrlDB = tfsUrl.valueId
                        let tfsUrlArray = Array(tfsUrl.valueId)
                        var tfsId: String = ""
                        for i in (0..<tfsUrlArray.count).reversed() {
                            if tfsUrlArray[i] != "/" {
                                tfsId = String(tfsUrlArray[i]) + tfsId
                            } else {
                                break
                            }
                        }
                        if tfsId.count > 10,
                            let last = tfsId.components(separatedBy: "_workitems?id=").last,
                            let first = last.components(separatedBy: "&_a=edit").first {
                            tfsId = first
                            
                            
                        }
                        if let tfsId = Int32(tfsId) {
                            tfsIdDB = tfsId
                            
                        }
                    }
                    var quart: String?
                    if let quartId = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.quart]}).first?.value {
                        quart = quarts.filter({$0.guid == quartId}).first?.name
                        
                    }
                    var deathLine: String?
                    if let deathLineNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.deathline]}).first {
                        deathLine = deathLineNew.valueId
                        
                    }
                    var priorityDB: Int32?
                    if let priotiryNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.priority]}).first {
                        if let priority = Int32(priotiryNew.valueId) {
                            priorityDB = priority
                        }
                    }
                    
                    let dateCreate =  eus1C.dateCreate
                    let dateBegin = eus1C.dateRegistration
                    let noShow = eus1C.deletionMark
                    
                    var stateId = ""
                    if let stateJson = eusStateJSON?.value.filter({$0.id == eus1C.id}).first?.name {
                        if let state = states.filter({$0.name == stateJson}).first {
                            stateId = state.guid
                        } else {
                            stateId = String(states.count)
                            let stateDB = State.init(id: nil, guid: stateId, name: stateJson)
                            let _ = stateDB.save(on: req)
                            states.append(stateDB)
                        }
                    }
                    
                    
                    if var eusDB = epicUserStories.filter({$0.guid == eus1C.id}).first {
                        if eusDB.dataVersion != eus1C.dataVersion {
                            eusDB.dataVersion = eus1C.dataVersion
                            eusDB.dateBegin = dateBegin
                            eusDB.dateCreate = dateCreate
                            eusDB.deathLine = deathLine
                            eusDB.name = eus1C.title
                            eusDB.noShow = noShow
                            eusDB.num = eus1C.num
                            eusDB.priority = priorityDB
                            eusDB.quart = quart
                            eusDB.businessValueId = businessValueId
                            eusDB.categoryId = categoryId
                            eusDB.deptId = eus1C.dept
                            eusDB.directionId = directionId
                            eusDB.productOwnerId = eus1C.productOwnerId
                            eusDB.tacticId = tacticId
                            eusDB.storePointsAnaliticPlane = storePointsAnaliticPlane
                            eusDB.storePointsDevPlane = storePointsDevPlane
                            eusDB.analiticId = analiticId
                            eusDB.stateId = stateId
                            let _ = eusDB.save(on: req)
                        }
                    } else {
                        let eusDB = EpicUserStory.init(id: nil, guid: eus1C.id, dataVersion: eus1C.dataVersion, dateBegin: dateBegin, dateCreate: dateCreate, dateEnd: nil, deathLine: deathLine, name: eus1C.title, noShow: noShow, num: eus1C.num, priority: priorityDB, quart: quart, businessValueId: businessValueId, categoryId: categoryId, deptId: eus1C.dept, directionId: directionId, productId: nil, productOwnerId: eus1C.productOwnerId, stateId: stateId, tacticId: tacticId, storePointsAnaliticFact: nil, storePointsAnaliticPlane: storePointsAnaliticPlane, storePointsDevFact: nil, storePointsDevPlane: storePointsDevPlane, tfsAnalitic: nil, tfsBeginDate: nil, tfsBusinessArea: nil, tfsBusinessValue: nil, tfsCategory: nil, tfsDateCreate: nil, tfsEndDate: nil, tfsId: tfsIdDB, tfsLastChangeDate: nil, tfsParentWorkItemUrl: nil, tfsPriority: nil, tfsProductOwner: nil, tfsQuart: nil, tfsState: nil, tfsStorePointAnaliticFact: nil, tfsStorePointAnaliticPlan: nil, tfsStorePointDevFact: nil, tfsStorePointDevPlan: nil, tfsStorePointFact: nil, tfsStorePointPlan: nil, tfsTitle: nil, tfsUrl: tfsUrlDB, tfsWorkItemType: nil, analiticId: analiticId)
                        // let _ = eusDB.save(on: req)
                        epicUserStories.append(eusDB)
                    }
                }
            }
        }
        self.globalSettings.saveLoadLog(date: Date(), name: "Разбор:", description: "\(#function)", value: nil, time: nil, req: req)
    }
    
    
}
