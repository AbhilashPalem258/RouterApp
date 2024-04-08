//
//  Coordinator.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import Foundation
import UIKit

protocol RoutableCoordinator: AnyObject {
    func rootViewController() -> UIViewController
    
    init(router: Router, context: Router.Context?)
}
