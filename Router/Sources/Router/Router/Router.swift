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
    
    func setRoot(_ id: String, params: [String: Any]? = nil) throws {
        let routerItem = try routerConfig.getRouterItem(with: id)
        let type = try routerItem.getCoordinatorType()
        var context: RoutingContext = .create(routerItem: routerItem, params: params)
        
        setRootCoordinator(type, context: context)
    }
    
    func push(_ id: String, params: [String: Any]? = nil) throws {
        let routerItem = try routerConfig.getRouterItem(with: id)
        let type = try routerItem.getCoordinatorType()
        var context: RoutingContext = .create(routerItem: routerItem, params: params)
        
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
    
    func present(_ id: String, params: [String: Any]? = nil, completion: ((any Routing) -> Void)? = nil) throws {
        let routerItem = try routerConfig.getRouterItem(with: id)
        let type = try routerItem.getCoordinatorType()
        var context: RoutingContext = .create(routerItem: routerItem, params: params)
        
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
}
