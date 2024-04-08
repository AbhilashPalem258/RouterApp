//
//  FirstLoginScreenCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import UIKit
import Combine

final class GlassBGLoginInput: Decodable {
    let username: String
    let title: String
}

final class GlassBGLoginCoordinator: RoutableCoordinator {
    init(router: Router, context: Router.Context?) {
        self.input = context?.data as? GlassBGLoginInput
        self.router = router
    }
    
    private let router: Router
    private var input: GlassBGLoginInput?
    private var cancellables = Set<AnyCancellable>()
    
    func rootViewController() -> UIViewController {
        let viewModel = GlassBGLoginViewModel()
        viewModel.backButtonClicked
            .sink { [weak self] in
                self?.pop()
            }
            .store(in: &cancellables)
        return GlassBGLoginScreen(viewModel: viewModel).viewController()
    }
    
    func pop() {
        router.pop(animated: true)
    }
}