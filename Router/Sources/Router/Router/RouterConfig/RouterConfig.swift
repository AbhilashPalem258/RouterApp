//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation

struct RouterConfig {
    let items: [RouterConfigItem]
    init() throws {
        guard let url = Bundle.module.url(forResource: "Router", withExtension: "json")  else {
            throw "Failed to get local router json"
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.items = try decoder.decode([RouterConfigItem].self, from: data)
    }
    
    func getRouterItem(with id: String) throws -> RouterConfigItem {
        guard let index = items.firstIndex(where: {$0.id == id}) else {
            throw "Failed to get router config item for \(id)"
        }
        return self.items[index]
    }
}

struct RouterConfigItem: Decodable {
    let id: String
    let coordinatorType: String
    let inputType: String
    
    func getCoordinatorType() throws -> RoutableCoordinator.Type {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String, let type: RoutableCoordinator.Type = NSClassFromString("\(namespace).\(coordinatorType)") as? RoutableCoordinator.Type else {
            throw "Failed to get coordinator type for \(coordinatorType)"
        }
        return type
    }
    
    func getInputType() throws -> Decodable.Type {
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String, let type: Decodable.Type = NSClassFromString("\(namespace).\(inputType)") as? Decodable.Type else {
            throw "Failed to get input type for \(inputType)"
        }
        return type
    }
}
