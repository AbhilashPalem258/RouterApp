//
//  SecondLoginCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Router
import Combine

final class LoginKitCoordinator: RoutableCoordinator {
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    var router: any Routing
    private var cancellables = Set<AnyCancellable>()
    
    func rootViewController() -> UIViewController {
        let viewModel = LoginKit.AuthenicationViewModel()
        
        viewModel.loginSelected
            .sink {[weak self] in
                do {
                    try self?.router.push(NavigationKeys.loginUIKitAuthenicationView.rawValue)
                } catch {
                    logError("Failed to navigate to \(NavigationKeys.loginUIKitAuthenicationView.rawValue) error: \(error)")
                }
            }
            .store(in: &cancellables)
        
        viewModel.forgotPasswordSelected
            .sink {[weak self] in
                do {
                    try self?.router.present(NavigationKeys.loginKitForgotPasswordView.rawValue, completion: nil)
                } catch {
                    logError("Failed to navigate to \(NavigationKeys.loginKitForgotPasswordView.rawValue) error: \(error)")
                }
            }
            .store(in: &cancellables)
        
        viewModel.verifyClicked
            .sink { [weak self] in
                do {
                    try self?.router.push(NavigationKeys.gridPaginationView.rawValue)
                } catch {
                    logError("Failed to navigate to \(NavigationKeys.gridPaginationView.rawValue) error: \(error)")
                }
            }
            .store(in: &cancellables)
        
        viewModel.backButtonClicked
            .sink { [weak self] in
                self?.router.dismiss(completion: nil)
            }
            .store(in: &cancellables)
        
        return LoginKit.AuthenicationView(viewModel: viewModel).viewController()
    }
}
