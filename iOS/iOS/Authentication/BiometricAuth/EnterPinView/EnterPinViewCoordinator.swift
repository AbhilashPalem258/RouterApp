//
//  EnterPinViewCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine
import Router
import OSLog

class EnterPinInputModel: Decodable {
    let name: String
    let age: Int
    let seniorCitizen: Bool
}

final class EnterPinViewCoordinator: RoutableCoordinator {
    
    private var cancellables = Set<AnyCancellable>()
    private var input: EnterPinInputModel?
    
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
        self.input = context.data as? EnterPinInputModel
        logInfo("[EnterPinViewCoordinator] RoutingContext input: \(String(describing: input)), params: \(String(describing: context.params))")
        self.router = router
    }
    
    func onSuccessfulAuthentication() {
        do {
            try router.push(NavigationKeys.gridPaginationView.rawValue)
        } catch {
            logError("Failed to navigate to \(NavigationKeys.gridPaginationView.rawValue) error: \(error)")
        }
    }
    
    func onBackPress() {
        router.pop(animated: true)
    }
    
    func onForgotPinPress() {
        do {
            try router.push(NavigationKeys.loginKitForgotPasswordView.rawValue)
        } catch {
            logError("Failed to navigate to \(NavigationKeys.loginKitForgotPasswordView.rawValue) error: \(error)")
        }
    }
}
