//
//  Router.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit

extension UIWindow {
    func mainRouter() -> Router {
        let router = Router()
        self.rootViewController = router.navController
        return router
    }
}

class Router {
    
    fileprivate let navController: UINavigationController
    private var childRouter: Router?
    weak var parent: Router?
    private var coordinatorRef = [any RoutableCoordinator]()
    let id: UUID
    private let routerJson = RouterJson()
    
    fileprivate init() {
        self.id = UUID()
        self.navController = UINavigationController()
    }
    
    func setRoot(_ id: String) {
        guard let routerItem = routerJson?.getRouterItem(with: id) as? RouterJsonItem, let type = classFromString(routerItem.coordinatorType) as? RoutableCoordinator.Type else {
            return
        }
        setRootCoordinator(type)
    }
    
    func push(_ id: String, params: [String: String]? = nil) {
        guard let routerItem = routerJson?.getRouterItem(with: id) as? RouterJsonItem, let type = classFromString(routerItem.coordinatorType) as? RoutableCoordinator.Type else {
            return
        }
        
        var context: Context? = nil
        if let params, !params.isEmpty, !routerItem.inputType.isEmpty, let inputType = classFromString(routerItem.inputType) as? Decodable.Type, let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),let model = try? JSONDecoder().decode(inputType, from: jsonData)  {
            context = Context(data: model)
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
    
    func present(_ id: String, params: [String: String]? = nil, completion: ((Router) -> Void)? = nil) {
        guard let routerItem = routerJson?.getRouterItem(with: id) as? RouterJsonItem, let type = classFromString(routerItem.coordinatorType) as? RoutableCoordinator.Type else {
            return
        }
        
        var context: Context? = nil
        if let params, !params.isEmpty, !routerItem.inputType.isEmpty, let inputType = classFromString(routerItem.inputType) as? Decodable.Type, let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),let model = try? JSONDecoder().decode(inputType, from: jsonData)  {
            context = Context(data: model)
        }
        
        presentCoordinator(type, context: context, completion: completion)
    }
    
    func dismiss(completion: ((Router) -> Void)? = nil) {
        self.parent?.dismissChild { parentRouter in
            completion?(parentRouter)
        }
    }
    
    func setRootCoordinator<Coordinator: RoutableCoordinator>(_ coordinatorType: Coordinator.Type, context: Context? = nil) {
        self.coordinatorRef.removeAll()
        self.navController.viewControllers.removeAll()
        pushCoordinator(coordinatorType, context: context)
    }
    
    func pushCoordinator<Coordinator: RoutableCoordinator>(_ coordinatorType: Coordinator.Type, context: Context? = nil) {
        let coordinator = coordinatorType.init(router: self, context: context)
        coordinatorRef.append(coordinator)
        let viewControllerToPush = coordinator.rootViewController()
        self.navController.pushViewController(viewControllerToPush, animated: true)
    }
    
    func presentCoordinator<Coordinator: RoutableCoordinator>(_ coordinatorType: Coordinator.Type, context: Context? = nil, completion: ((Router) -> Void)?) {
        let newRouter = Router()
        newRouter.parent = self
        childRouter = newRouter
        newRouter.setRootCoordinator(coordinatorType, context: context)
        newRouter.navController.modalPresentationStyle = .fullScreen
        self.navController.present(newRouter.navController, animated: true) {
            completion?(newRouter)
        }
    }
    
    func dismissChild(completion: ((Router) -> Void)?) {
        childRouter?.cleanup()
        childRouter = nil
        self.navController.dismiss(animated: true) {
            completion?(self)
        }
    }
    
    func cleanup() {
        self.childRouter = nil
        self.coordinatorRef.removeAll()
        self.parent = nil
    }
    
    func classFromString(_ className: String) -> AnyClass! {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!
        return cls
    }
    
    
    struct Context {
        let data: any Decodable
    }
}

struct RouterJson {
    let items: [RouterJsonItem]
    init?() {
        guard let url = Bundle.main.url(forResource: "Router", withExtension: "json"), let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.items = try! decoder.decode([RouterJsonItem].self, from: data)
    }
    
    func getRouterItem(with id: String) -> RouterJsonItem? {
        guard let index = items.firstIndex(where: {$0.id == id}) else {
            return nil
        }
        return self.items[index]
    }
}

struct RouterJsonItem: Decodable {
    let id: String
    let coordinatorType: String
    let inputType: String
}
