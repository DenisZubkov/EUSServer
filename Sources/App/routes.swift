import Routing
import Vapor
import Foundation

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    //let dataProvider = DataProvider()
    
    
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("refresh", "1c") { req -> String in
        let loadData = LoadDataProvider()
        loadData.getAllData(req: req)
        return "Refresh started"
    }
    
    router.get("refresh") { req -> String in
        let loadData = LoadDataProvider()
        return "\(loadData.TestConnectAPI(req: req))"
    }
    
    router.get("test") { req -> Future<Response> in
        let client = try req.make(Client.self)
        print(client) // Client
        let res = client.get("http://zubkoff:!den20zu10@tfs1.tbm.ru:8080/tfs/DefaultCollection/_apis/wit/workitems?ids=4644,4642&$expand=relations&api-version=3.2")
        _ = res.flatMap(to: Response.self) { response -> Future<Response> in
            let globalSettings = GlobalSettings()
            print(response.http.body)
            if let data = response.http.body.data {
                let string = String(data: data, encoding: .utf8)
                let subString = String((string?.prefix(100))!)
                globalSettings.saveLoadLog(date: Date(), name: "Загрузка данных из TFS", description: subString, value: -1, time: nil, req: req)
            }
            return res
        }
        return res
//        return
        
    }
    
    
    
    router.get("refresh", "tfs") { req -> String in
        let loadData = LoadDataProvider()
        loadData.getTFSData(req: req)
        return "Refresh started"
    }
    
    router.get("Properties") { req -> Future<[Property]> in
        return Property.query(on: req).all()
    }
    
    router.get("PropertyValues") { req -> Future<[PropertyValue]> in
        return PropertyValue.query(on: req).all()
    }
    
    router.get("StrategicTargets") { req -> Future<[StrategicTarget]> in
        return StrategicTarget.query(on: req).all()
    }
    
    router.get("Tactics") { req -> Future<[Tactic]> in
        return Tactic.query(on: req).all()
    }
    
    router.get("Categories") { req -> Future<[Category]> in
        return Category.query(on: req).all()
    }
    
    router.get("BusinessValues") { req -> Future<[BusinessValue]> in
        return BusinessValue.query(on: req).all()
    }
    
    router.get("TypeTeams") { req -> Future<[TypeTeam]> in
        return TypeTeam.query(on: req).all()
    }
    
    router.get("Depts") { req -> Future<[Dept]> in
        return Dept.query(on: req).all()
    }
    
    router.get("Teams") { req -> Future<[Team]> in
        return Team.query(on: req).all()
    }
    
    router.get("Users") { req -> Future<[User]> in
        return User.query(on: req).all()
    }
    
    router.get("Directions") { req -> Future<[Direction]> in
        return Direction.query(on: req).all()
    }
    
    router.get("Quotas") { req -> Future<[Quota]> in
        return Quota.query(on: req).all()
    }
    
//    router.get("EpicUserStories") { req -> Future<[EpicUserStory]> in
//        return EpicUserStory.query(on: req).all()
//    }
    
    router.get("EpicUserStories", "direction", String.parameter) { req -> Future<[EpicUserStory]> in
        let directionId = try req.parameters.next(String.self)
        let query = EpicUserStory.query(on: req).filter(\EpicUserStory.directionId, ._equal,  directionId).all()
        return query
    }
    
    router.get("EpicUserStories") { req -> Future<[EpicUserStory]> in
        let query = EpicUserStory.query(on: req).all()
        return query
    }
    
    router.get("EpicUserStory", Int32.parameter) { req -> Future<[EpicUserStory]> in
        let tfsId = try req.parameters.next(Int32.self)
        let query = EpicUserStory.query(on: req).filter(\EpicUserStory.tfsId, ._equal,  tfsId).all()
        return query
    }
    
    router.get("TreeWorkItems", "Level", Int.parameter) { req -> Future<[TreeWorkItem]> in
        let level = try req.parameters.next(Int.self)
        let query = TreeWorkItem.query(on: req).filter(\TreeWorkItem.level, ._equal,  level).all()
        return query
    }
    
    router.post(Category.self, at: "category/create") { req, category -> Future<Category> in
        return category.save(on: req)
    }
    router.post(Property.self, at: "property/create") { req, property -> Future<Property> in
        return property.save(on: req)
    }
}
