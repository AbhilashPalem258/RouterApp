//
//  ForgotPasswordCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import UIKit
import Combine
import Router

final class ResetPasswordCoordinator: RoutableCoordinator {
    
    private var cancellables = Set<AnyCancellable>()

    func rootViewController() -> UIViewController {
        let viewModel = LoginKit.ResetPasswordViewModel()
        viewModel.onSubmitClick
            .sink { [weak self] in
                self?.onResetSubmitClick()
            }
            .store(in: &cancellables)
        return LoginKit.ResetPasswordView(viewModel: viewModel).viewController()
    }
    
    private let router: any Routing
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    func onResetSubmitClick() {
        router.dismiss { parentRouter in
            do {
                try parentRouter.push(NavigationKeys.gridPaginationView.rawValue)
            } catch {
                logError("Failed to navigate to \(NavigationKeys.gridPaginationView.rawValue) error: \(error)")
            }
        }
    }
}
