//
//  SecondLoginCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Router

final class LoginKitCoordinator: RoutableCoordinator {
    init(router: some Routing, context: RoutingContext?) {
        self.router = router
    }
    
    var router: any Routing
    
    func rootViewController() -> UIViewController {
        LoginKit.AuthenicationView().viewController()
    }
}
