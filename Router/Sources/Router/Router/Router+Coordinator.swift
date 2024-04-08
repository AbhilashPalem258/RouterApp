//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation

extension Router {
    func setRootCoordinator<Coordinator: RoutableCoordinator>(_ coordinatorType: Coordinator.Type, context: RoutingContext? = nil) {
        self.coordinatorRef.removeAll()
        self.navController.viewControllers.removeAll()
        pushCoordinator(coordinatorType, context: context)
    }
    
    func pushCoordinator<Coordinator: RoutableCoordinator>(_ coordinatorType: Coordinator.Type, context: RoutingContext? = nil) {
        let coordinator = coordinatorType.init(router: self, context: context)
        coordinatorRef.append(coordinator)
        let viewControllerToPush = coordinator.rootViewController()
        self.navController.pushViewController(viewControllerToPush, animated: true)
    }
    
    func presentCoordinator<Coordinator: RoutableCoordinator>(_ coordinatorType: Coordinator.Type, context: RoutingContext? = nil, completion: ((any Routing) -> Void)?) throws {
        let newRouter = try Router()
        newRouter.parent = self
        childRouter = newRouter
        newRouter.setRootCoordinator(coordinatorType, context: context)
        newRouter.navController.modalPresentationStyle = .fullScreen
        self.navController.present(newRouter.navController, animated: true) {
            completion?(newRouter)
        }
    }
}
