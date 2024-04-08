//
//  File.swift
//  
//
//  Created by Abhilash Palem on 08/04/24.
//

import Foundation

public protocol Routing: AnyObject {
    func setRoot(_ id: String, params: [String: String]?) throws
    func push(_ id: String, params: [String: String]?) throws
    func pop(animated: Bool)
    func present(_ id: String, params: [String: String]?, completion: ((any Routing) -> Void)?) throws
    func dismiss(completion: ((any Routing) -> Void)?)
    func dismissChild(completion: ((any Routing) -> Void)?)
    
    func setRoot(_ id: String) throws
    func push(_ id: String) throws
    func present(_ id: String, completion: ((any Routing) -> Void)?) throws
}
