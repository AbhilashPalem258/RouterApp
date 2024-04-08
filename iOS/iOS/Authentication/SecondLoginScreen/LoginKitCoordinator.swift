//
//  SecondLoginCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit

final class LoginKitCoordinator: RoutableCoordinator {
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    var router: Router
    
    func rootViewController() -> UIViewController {
        LoginKit.AuthenicationView().viewController()
    }
}
