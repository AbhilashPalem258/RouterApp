//
//  ResetPasswordCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import UIKit
import Combine

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
    
    private let router: Router
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    func onSubmitClick() {
        router.push("LoginKit.VerifyOTPView")
    }
}
