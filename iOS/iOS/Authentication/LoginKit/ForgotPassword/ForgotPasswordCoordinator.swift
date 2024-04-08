//
//  ResetPasswordCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import UIKit
import Combine
import Router

final class ForgotPasswordCoordinator: RoutableCoordinator {
    private var cancellables = Set<AnyCancellable>()

    func rootViewController() -> UIViewController {
        let viewModel = LoginKit.ForgotPasswordViewModel()
        viewModel.onSubmitClick
            .sink { [weak self] in
                self?.onSubmitClick()
            }
            .store(in: &cancellables)
        return LoginKit.ForgotPasswordView(viewModel: viewModel).viewController()
    }
    
    private let router: any Routing
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    func onSubmitClick() {
        do {
            try router.push(NavigationKeys.loginKitVerifyOTPView.rawValue)
        } catch {
            debugPrint("\(error)")
        }
    }
}
