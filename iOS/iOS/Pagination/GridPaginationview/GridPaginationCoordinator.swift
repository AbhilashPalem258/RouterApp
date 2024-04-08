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
        return GridPaginationView(vm: viewModel).viewController(navBarHidden: false)
    }
    private let router: any Routing
    init(router: some Routing, context: RoutingContext?) {
        self.router = router
    }
}
