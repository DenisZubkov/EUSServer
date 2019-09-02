import Vapor
import FluentMySQL
import Fluent
import Foundation
/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Configure the rest of your application here
    let directoryConfig = DirectoryConfig.detect()
    services.register(directoryConfig)
    
    try services.register(FluentMySQLProvider())
    
    let mysqlConfig = MySQLDatabaseConfig(hostname: "dcluster-node-2.tbm.ru", port: 3306, username: "root", password: "fox", database: "epicus", capabilities: .default, characterSet: .utf8_general_ci, transport: .unverifiedTLS)
    let mysql = MySQLDatabase(config: mysqlConfig)
    
    var databaseConfig = DatabasesConfig()
    databaseConfig.add(database: mysql, as: .mysql)
    services.register(databaseConfig)
    
    var migrationConfig = MigrationConfig()
    migrationConfig.add(model: Property.self, database: .mysql)
    migrationConfig.add(model: PropertyValue.self, database: .mysql)
    migrationConfig.add(model: StrategicTarget.self, database: .mysql)
    migrationConfig.add(model: Tactic.self, database: .mysql)
    migrationConfig.add(model: Category.self, database: .mysql)
    migrationConfig.add(model: BusinessValue.self, database: .mysql)
    migrationConfig.add(model: TypeTeam.self, database: .mysql)
    migrationConfig.add(model: Dept.self, database: .mysql)
    migrationConfig.add(model: Team.self, database: .mysql)
    migrationConfig.add(model: User.self, database: .mysql)
    migrationConfig.add(model: Direction.self, database: .mysql)
    migrationConfig.add(model: Quota.self, database: .mysql)
    migrationConfig.add(model: EpicUserStory.self, database: .mysql)
    migrationConfig.add(model: TreeWorkItem.self, database: .mysql)
    migrationConfig.add(model: Product.self, database: .mysql)
    migrationConfig.add(model: State.self, database: .mysql)
    migrationConfig.add(model: UserStory.self, database: .mysql)
    migrationConfig.add(model: UserStoryType.self, database: .mysql)
    migrationConfig.add(model: Quart.self, database: .mysql)
    migrationConfig.add(model: LoadLog.self, database: .mysql)
    services.register(migrationConfig)
    
}
