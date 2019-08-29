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
    
    router.get("EpicUserStories") { req -> Future<[EpicUserStory]> in
        return EpicUserStory.query(on: req).all()
    }
    
    router.post(Category.self, at: "category/create") { req, category -> Future<Category> in
        return category.save(on: req)
    }
    router.post(Property.self, at: "property/create") { req, property -> Future<Property> in
        return property.save(on: req)
    }
}
