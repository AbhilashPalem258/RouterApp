//
//  ForgotPasswordCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import UIKit
import Combine

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
    
    private let router: Router
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    func onResetSubmitClick() {
        router.dismiss { parentRouter in
            parentRouter.push("GridPaginationView")
        }
    }
}
