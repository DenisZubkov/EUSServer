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
    
    router.get("test", "1c") { req -> String in
        let loadData = LoadDataProvider()
        return "\(loadData.TestConnectAPI(req: req, type: .json))"
    }
    
    router.get("test", "tfs") { req -> String in
        let loadData = LoadDataProvider()
        return "\(loadData.TestConnectAPI(req: req, type: .tfs))"
    }
    
    router.get("test") { req -> Future<[LoadLog]> in
        let gs = GlobalSettings()
        let client = try req.make(Client.self)
        let res = client.get("http://\(gs.login):\(gs.password)@10.1.0.70:80/DocMng/odata/standard.odata/ChartOfCharacteristicTypes_%D0%94%D0%BE%D0%BF%D0%BE%D0%BB%D0%BD%D0%B8%D1%82%D0%B5%D0%BB%D1%8C%D0%BD%D1%8B%D0%B5%D0%A0%D0%B5%D0%BA%D0%B2%D0%B8%D0%B7%D0%B8%D1%82%D1%8B%D0%98%D0%A1%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D1%8F/?$select=Ref_Key,%20%D0%97%D0%B0%D0%B3%D0%BE%D0%BB%D0%BE%D0%B2%D0%BE%D0%BA,%20DataVersion&$filter=Ref_Key%20eq%20guid'fef304c1-bad8-11e7-acc5-0050568d26bf'%20or%20Ref_Key%20eq%20guid'89778d28-bad4-11e7-acc5-0050568d26bf'%20or%20Ref_Key%20eq%20guid'ba84e2e0-67f1-11e9-afc8-0050568d26bf'%20or%20Ref_Key%20eq%20guid'e098b409-6a5e-11e9-afc8-0050568d26bf'%20or%20Ref_Key%20eq%20guid'19bf6ca6-bad9-11e7-acc5-0050568d26bf'%20or%20Ref_Key%20eq%20guid'71c4c213-08c4-11e9-94b6-0050568d26bf'%20or%20Ref_Key%20eq%20guid'8815a07f-09c5-11e9-94b6-0050568d26bf'%20or%20Ref_Key%20eq%20guid'33e47edd-2f7b-11e9-8e2e-0050568d26bf'%20or%20Ref_Key%20eq%20guid'e945dcba-08c6-11e9-94b6-0050568d26bf'%20or%20Ref_Key%20eq%20guid'd342c29c-5d40-11e6-850d-0050568d26bf'%20or%20Ref_Key%20eq%20guid'b01fa2f0-08c4-11e9-94b6-0050568d26bf'%20or%20Ref_Key%20eq%20guid'1f3da85c-2f7b-11e9-8e2e-0050568d26bf'%20or%20Ref_Key%20eq%20guid'b64ba876-7f57-11e8-8acb-0050568d26bf'%20or%20Ref_Key%20eq%20guid'ec76a4bf-5a81-11e9-a906-0050568d26bf'%20or%20Ref_Key%20eq%20guid'dc18d546-08c6-11e9-94b6-0050568d26bf'%20or%20Ref_Key%20eq%20guid'0b335ce8-6739-11e9-afc8-0050568d26bf'%20or%20Ref_Key%20eq%20guid'd36bb213-6a5e-11e9-afc8-0050568d26bf'%20or%20Ref_Key%20eq%20guid'7f9f2184-67e7-11e9-afc8-0050568d26bf'%20or%20Ref_Key%20eq%20guid'71998249-67e7-11e9-afc8-0050568d26bf'%20or%20Ref_Key%20eq%20guid'32070e46-bad8-11e7-acc5-0050568d26bf'%20or%20Ref_Key%20eq%20guid'838c9a73-17b6-11e9-8e2e-0050568d26bf'&$format=json")
        print(res)
        _ = res.flatMap(to: Response.self) { response -> Future<Response> in
            print(response)
            if let data = response.http.body.data {
                let string = String(data: data, encoding: .utf8)
                let subString = String((string?.prefix(100))!)
                gs.saveLoadLog(date: Date(), name: "Загрузка данных из 1C", description: subString, value: -1, time: nil, req: req)
            }
            return res
        }
        return LoadLog.query(on: req).all()
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
