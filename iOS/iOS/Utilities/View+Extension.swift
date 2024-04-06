//
//  View+Extension.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import SwiftUI

extension View {
    var viewController : UIViewController {
        UIHostingController(rootView: self)
    }
}
