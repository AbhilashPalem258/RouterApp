//
//  BiometricAuthCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine

final class BiometricAuthCoordinator: RoutableCoordinator {
    
    private var router: Router
    private var cancellables = Set<AnyCancellable>()
    
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
    
    func rootViewController() -> UIViewController {
        let viewModel = BiometricAuthViewModel()
        viewModel.enterPinSelected
            .sink {[weak self] in
                self?.showEnterPinView()
            }
            .store(in: &cancellables)
        
        return BiometricAuthScreen(viewModel: viewModel).viewController()
    }
    
    func showEnterPinView() {
        router.present("EnterPinView")
    }
}
