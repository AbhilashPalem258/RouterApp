//
//  GridPaginationCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import Combine
import UIKit
import Router

final class GridPaginationCoordinator: RoutableCoordinator {
    
    func rootViewController() -> UIViewController {
        let viewModel = GridPaginationViewModel()
        viewModel.backButtonClicked
            .sink { [weak self] in
                self?.goBack()
            }
            .store(in: &cancellables)
        return GridPaginationView(vm: viewModel).viewController(navBarHidden: false)
    }
    private let router: any Routing
    private var cancellables = Set<AnyCancellable>()
    
    init(router: some Routing, context: RoutingContext) {
        self.router = router
    }
    
    func goBack() {
        self.router.pop(animated: true)
    }
}
