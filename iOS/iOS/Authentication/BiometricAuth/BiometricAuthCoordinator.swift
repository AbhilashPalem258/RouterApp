//
//  BiometricAuthCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine
import Router

final class BiometricAuthCoordinator: RoutableCoordinator {
    
    private var router: any Routing
    private var cancellables = Set<AnyCancellable>()
    
    init(router: some Routing, context: RoutingContext?) {
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
        do {
            try router.present("EnterPinView", completion: nil)
        } catch {
            debugPrint("\(error)")
        }
    }
}
