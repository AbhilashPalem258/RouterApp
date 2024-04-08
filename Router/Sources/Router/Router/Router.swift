// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public extension UIWindow {
    func mainRouter() throws -> some Routing {
        let router = try Router()
        self.rootViewController = router.navController
        return router
    }
}

final class Router: Routing {
    
    let navController: UINavigationController
    var childRouter: Router?
    weak var parent: Router?
    var coordinatorRef = [any RoutableCoordinator]()
    let id: UUID
    let routerConfig: RouterConfig
    
    init() throws {
        self.routerConfig = try RouterConfig()
        self.id = UUID()
        self.navController = UINavigationController()
    }
    
    func setRoot(_ id: String, params: [String: String]? = nil) throws {
        let routerItem = try routerConfig.getRouterItem(with: id)
        let type = try coordinatorTypeOf(routerItem.coordinatorType)
        setRootCoordinator(type)
    }
    
    func push(_ id: String, params: [String: String]? = nil) throws {
        let routerItem = try routerConfig.getRouterItem(with: id)
        let type = try coordinatorTypeOf(routerItem.coordinatorType)
        var context: RoutingContext? = nil
        if let params, !params.isEmpty, !routerItem.inputType.isEmpty  {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let inputType = try inputTypeOf(routerItem.inputType)
            let model = try JSONDecoder().decode(inputType, from: jsonData)
            context = RoutingContext(data: model)
        }
        
        pushCoordinator(type, context: context)
    }
    
    func pop(animated: Bool = true) {
        _ = coordinatorRef.popLast()
        if coordinatorRef.isEmpty {
            dismiss()
        } else {
            self.navController.popViewController(animated: animated)
        }
    }
    
    func present(_ id: String, params: [String: String]? = nil, completion: ((any Routing) -> Void)? = nil) throws {
        let routerItem = try routerConfig.getRouterItem(with: id)
        let type = try coordinatorTypeOf(routerItem.coordinatorType)
        var context: RoutingContext? = nil
        if let params, !params.isEmpty, !routerItem.inputType.isEmpty  {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let inputType = try inputTypeOf(routerItem.inputType)
            let model = try JSONDecoder().decode(inputType, from: jsonData)
            context = RoutingContext(data: model)
        }
        
        try presentCoordinator(type, context: context, completion: completion)
    }
    
    func dismiss(completion: ((any Routing) -> Void)? = nil) {
        self.parent?.dismissChild { parentRouter in
            completion?(parentRouter)
        }
    }
    
    
    func dismissChild(completion: ((any Routing) -> Void)?) {
        childRouter?.cleanup()
        childRouter = nil
        self.navController.dismiss(animated: true) {
            completion?(self)
        }
    }
    
    func setRoot(_ id: String) throws {
        try setRoot(id, params: nil)
    }
    
    func push(_ id: String) throws {
        try push(id, params: nil)
    }
    
    func present(_ id: String, completion: ((Routing) -> Void)?) throws {
        try present(id, params: nil, completion: completion)
    }
    
    func cleanup() {
        self.childRouter = nil
        self.coordinatorRef.removeAll()
        self.parent = nil
    }
    
    func coordinatorTypeOf(_ name: String) throws -> RoutableCoordinator.Type {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String, let type: RoutableCoordinator.Type = NSClassFromString("\(namespace).\(name)") as? RoutableCoordinator.Type else {
            throw "Failed to get coordinator type for \(name)"
        }
        return type
    }
    
    func inputTypeOf(_ name: String) throws -> Decodable.Type {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String, let type: Decodable.Type = NSClassFromString("\(namespace).\(name)") as? Decodable.Type else {
            throw "Failed to get input type for \(name)"
        }
        return type
    }
}
