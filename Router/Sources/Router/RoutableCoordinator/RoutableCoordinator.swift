//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation
import UIKit

public struct RoutingContext {
    public let data: any Decodable
}

public protocol RoutableCoordinator: AnyObject {
    func rootViewController() -> UIViewController
    
    init(router: some Routing, context: RoutingContext?)
}
