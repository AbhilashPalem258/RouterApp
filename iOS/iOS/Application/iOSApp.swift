//
//  iOSApp.swift
//  iOS
//
//  Created by Abhilash Palem on 30/03/24.
//

import SwiftUI

struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GridPaginationView(vm: .init())
                    .preferredColorScheme(.light)
            }
        }
    }
}
