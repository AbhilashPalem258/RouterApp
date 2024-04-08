//
//  VerifyOTPCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import UIKit
import Combine
import Router

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
    
    private let router: any Routing
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    func onResetSubmitClick() {
        do {
            try router.push(NavigationKeys.loginKitResetPasswordView.rawValue)
        } catch {
            debugPrint("\(error)")
        }
    }
}
