//
//  EnterPinViewCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine

final class EnterPinViewCoordinator: RoutableCoordinator {
    
    private var cancellables = Set<AnyCancellable>()
    
    func rootViewController() -> UIViewController {
        let viewModel = EnterPinViewModel()
        viewModel.successfulLogin
            .sink { [weak self] in
                self?.onSuccessfulAuthentication()
            }
            .store(in: &cancellables)
        
        viewModel.backPressed
            .sink { [weak self] in
                self?.onBackPress()
            }
            .store(in: &cancellables)
        
        viewModel.forgotPinClick
            .sink { [weak self] in
                self?.onForgotPinPress()
            }
            .store(in: &cancellables)
        
        return EnterPinView(viewModel: viewModel).viewController()
    }
    
    private let router: Router
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    func onSuccessfulAuthentication() {
        router.push("GridPaginationView")
    }
    
    func onBackPress() {
        router.pop()
    }
    
    func onForgotPinPress() {
        router.push("LoginKit.ForgotPasswordView")
    }
}
