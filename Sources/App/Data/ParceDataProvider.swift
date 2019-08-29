//
//  ParceDataProvider.swift
//  App
//
//  Created by Denis Zubkov on 14/08/2019.
//

import Foundation
import Routing
import Vapor

class ParceDataProvider {
    
    let globalSettings = GlobalSettings()
    var usersTeams: [String:String] = [:]
    let type = QueryResultFormat.json
    
    
    //MARK: 1C - PARSING
    
    //MARK: Parameters - update
    func parceParameters(properties: inout [Property], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "0\(type.rawValue)") as? NSData {
            let data = nsData as Data
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
    }
    
    //MARK: PropertyValues - update
    func parceParameterValues(propertyValues: inout [PropertyValue], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "1\(type.rawValue)") as? NSData {
            let data = nsData as Data
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
    }
    
    //MARK: StrategicTargets, Tactics - update
    func parceStrategicTargetsAndTactics(properties: [Property], propertyValues: [PropertyValue], strategicTargets: inout [StrategicTarget], tactics: inout [Tactic], req: DatabaseConnectable)  {
        
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
    }
    
    
    //MARK: Categories - update
    func parceCategories(properties: [Property], propertyValues: [PropertyValue], categories: inout [Category], req: DatabaseConnectable)  {
        
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
    }
    
    
    
    //MARK: BusinessValues - update
    func parceBusinessValues(properties: [Property], propertyValues: [PropertyValue], businessValues: inout [BusinessValue], req: DatabaseConnectable)  {
        
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
    }
    
    //MARK: Quarts - update
    func parceQuarts(properties: [Property], propertyValues: [PropertyValue], quarts: inout [Quart], req: DatabaseConnectable)  {
        
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
    }
    
    //MARK: TypeTeams - update
    func parceTypeTeams(typeTeams: inout [TypeTeam], req: DatabaseConnectable)  {
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
    }
    
    
    
    // MARK: Dept - update
    func parceDepts(depts: inout [Dept], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "2\(type.rawValue)") as? NSData {
            let data = nsData as Data
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
    }
    
    // MARK: Teams - update
    func parceTeams(teams: inout [Team], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "3\(type.rawValue)") as? NSData {
            let data = nsData as Data
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
    }
    
    // MARK: Users - update
    func parceUsers(users: inout [User], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "4\(type.rawValue)") as? NSData {
            let data = nsData as Data
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
    }
    
    
    //MARK: Directions - update
    func parceDirections(directions: inout [Direction],  req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "6\(type.rawValue)") as? NSData {
            let data = nsData as Data
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
    }
    
    //MARK: Quotas - update
    func parceQuotas(quotas: inout [Quota], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "7\(type.rawValue)") as? NSData {
            let data = nsData as Data
            let quotasJSON: QuotasJSON? = self.globalSettings.getType(from: data)
            
            if let quotas1C = quotasJSON?.value {
                for quota1C in quotas1C {
                    guard let date = globalSettings.convertString1cToDate(from: quota1C.quart) else { return }
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
    }
    
    //MARK: EpicUserStories - update
    func parceEpicUserStories(directions: [Direction], categories: [Category], tactics: [Tactic], users: [User], quarts: [Quart], businessValues: [BusinessValue], states: inout [State], epicUserStories: inout [EpicUserStory], req: DatabaseConnectable)  {
        if let nsData = UserDefaults.standard.value(forKey: "5\(type.rawValue)") as? NSData,
            let nsStateData = UserDefaults.standard.value(forKey: "8\(type.rawValue)") as? NSData{
            let data = nsData as Data
            let stateData = nsStateData as Data
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
                    var deathLine: Date?
                    if let deathLineNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.deathline]}).first {
                        deathLine = globalSettings.convertString1cToDate(from: deathLineNew.valueId)
                        
                    }
                    var priorityDB: Int32?
                    if let priotiryNew = eus1C.дополнительныеРеквизиты.filter({$0.parameterId == globalSettings.parameterDict[.priority]}).first {
                        if let priority = Int32(priotiryNew.valueId) {
                            priorityDB = priority
                        }
                    }
                    
                    let dateCreate = globalSettings.convertString1cToDate(from: eus1C.dateCreate)
                    let dateBegin = globalSettings.convertString1cToDate(from: eus1C.dateRegistration)
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
    }
    
}
