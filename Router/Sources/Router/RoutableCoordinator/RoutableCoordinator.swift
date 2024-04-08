//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation
import UIKit

public struct RoutingContext {
    public let data: (any Decodable)?
    public let params: [String: Any]?
    
    static func create(routerItem: RouterConfigItem, params: [String: Any]?) -> RoutingContext {
        var inputModel: (any Decodable)?
        if let params, !params.isEmpty, !routerItem.inputType.isEmpty,
            let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted),
            let inputType = try? routerItem.getInputType(),
            let model = try? JSONDecoder().decode(inputType, from: jsonData) {
            inputModel = model
        }
        return RoutingContext(data: inputModel, params: params)
    }
}

public protocol RoutableCoordinator: AnyObject {
    func rootViewController() -> UIViewController
    
    init(router: some Routing, context: RoutingContext)
}
