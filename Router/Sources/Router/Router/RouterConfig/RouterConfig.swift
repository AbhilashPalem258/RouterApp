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
}
