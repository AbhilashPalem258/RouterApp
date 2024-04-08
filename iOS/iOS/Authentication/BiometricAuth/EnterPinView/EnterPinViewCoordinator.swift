//
//  EnterPinViewCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine
import Router

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
    
    private let router: any Routing
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    func onSuccessfulAuthentication() {
        do {
            try router.push(NavigationKeys.gridPaginationView.rawValue)
        } catch {
            debugPrint("\(error)")
        }
    }
    
    func onBackPress() {
        router.pop(animated: true)
    }
    
    func onForgotPinPress() {
        do {
            try router.push(NavigationKeys.loginKitForgotPasswordView.rawValue)
        } catch {
            debugPrint("\(error)")
        }
    }
}
