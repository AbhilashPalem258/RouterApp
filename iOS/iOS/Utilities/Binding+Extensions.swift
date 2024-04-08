//
//  Binding+Extensions.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import SwiftUI

extension Binding where Value == String {
    func limit(to length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}
