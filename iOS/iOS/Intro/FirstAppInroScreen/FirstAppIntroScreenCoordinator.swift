//
//  FirstAppIntroScreenCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine

private enum AuthOption: Int {
    case apple
    case phone
    case email
    case google
}

final class FirstAppIntroScreenCoordinator: RoutableCoordinator {
    
    private let router: Router
    
    private var cancellables = Set<AnyCancellable>()

    
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    func rootViewController() -> UIViewController {
        let viewModel = FirstAppIntroViewModel()
        viewModel.delegate = self
        return FirstAppIntroScreen(vm: viewModel).viewController()
    }
    
    func navigateToAppleAuth() {
        router.push("GlassBGLogin")
    }
    
    func navigateToPhoneAuth() {
        router.present("BiometricAuthLogin")
    }
    
    func navigateToEmailAuth() {
        router.present("LoginUIKit.AuthenicationView")
    }
    
    func navigateToGoogleAuth() {
        
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
