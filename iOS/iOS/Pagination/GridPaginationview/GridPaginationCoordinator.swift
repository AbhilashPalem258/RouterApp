//
//  GridPaginationCoordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import Combine
import UIKit

final class GridPaginationCoordinator: RoutableCoordinator {
    func rootViewController() -> UIViewController {
        let viewModel = GridPaginationViewModel()
        return GridPaginationView(vm: viewModel).viewController(navBarHidden: false)
    }
    private let router: Router
    init(router: Router, context: Router.Context?) {
        self.router = router
    }
}
