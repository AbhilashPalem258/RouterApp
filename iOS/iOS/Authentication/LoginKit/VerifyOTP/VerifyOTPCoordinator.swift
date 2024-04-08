//
//  VerifyOTPCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import UIKit
import Combine

final class VerifyOTPCoordinator: RoutableCoordinator {
    
    private var cancellables = Set<AnyCancellable>()

    func rootViewController() -> UIViewController {
        let viewModel = LoginKit.VerifyOTPViewModel()
        viewModel.onSubmitClick
            .sink { [weak self] in
                self?.onResetSubmitClick()
            }
            .store(in: &cancellables)
        return LoginKit.VerifyOTPView(viewModel: viewModel).viewController()
    }
    
    private let router: Router
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    func onResetSubmitClick() {
        router.push("LoginKit.ResetPasswordView")
    }
}
