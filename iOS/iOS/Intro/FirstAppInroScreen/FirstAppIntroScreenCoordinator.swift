//
//  FirstAppIntroScreenCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine
import Router

private enum AuthOption: Int {
    case apple
    case phone
    case email
    case google
}

final class FirstAppIntroScreenCoordinator: RoutableCoordinator {
    
    private let router: any Routing
    private var cancellables = Set<AnyCancellable>()

    
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    func rootViewController() -> UIViewController {
        let viewModel = FirstAppIntroViewModel()
        viewModel.delegate = self
        return FirstAppIntroScreen(vm: viewModel).viewController()
    }
    
    func navigateToAppleAuth() {
        do {
            try router.push(NavigationKeys.glassBGLogin.rawValue)
        } catch {
            logError("Failed to navigate to \(NavigationKeys.glassBGLogin.rawValue) error: \(error)")
        }
    }
    
    func navigateToPhoneAuth() {
        do {
            try router.present(NavigationKeys.biometricAuthLogin.rawValue, completion: nil)
        } catch {
            logError("Failed to navigate to \(NavigationKeys.biometricAuthLogin.rawValue) error: \(error)")
        }
    }
    
    func navigateToEmailAuth() {
        do {
            try router.present(NavigationKeys.loginUIKitAuthenicationView.rawValue, completion: nil)
        } catch {
            logError("Failed to navigate to \(NavigationKeys.loginUIKitAuthenicationView.rawValue) error: \(error)")
        }
    }
    
    func navigateToGoogleAuth() {
        do {
            try router.push(NavigationKeys.gridPaginationView.rawValue)
        } catch {
            logError("Failed to navigate to \(NavigationKeys.gridPaginationView.rawValue) error: \(error)")
        }
    }
}
extension FirstAppIntroScreenCoordinator: FirstAppIntroNavHandler {
    func didSelectedAuthOption(index: Int) {
        switch AuthOption(rawValue: index) {
        case .apple:
            self.navigateToAppleAuth()
        case .phone:
            navigateToPhoneAuth()
        case .email:
            navigateToEmailAuth()
        default:
            break
        }
    }
}
