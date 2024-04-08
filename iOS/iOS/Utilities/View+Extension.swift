//
//  View+Extension.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//

import SwiftUI

extension View {
    func viewController(navBarHidden: Bool = true) -> UIViewController {
        UIHostingController(rootView:
            self
            .toolbar(navBarHidden ? .hidden : .visible, for: .navigationBar)
        )
    }
    
    func hSpacing(alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vSpacing(alignment: Alignment = .center) -> some View {
        frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func disableWithOpacity(_ state: Bool = true) -> some View {
        self
            .disabled(state)
            .opacity(state ? 0.6 : 1.0)
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func backButton(action: @escaping () -> Void) -> some View {
        self
            .overlay(alignment: .topLeading) {
                Button {
                    action()
                } label: {
                    Image(systemName: "arrow.backward")
                        .font(.title2.bold())
                        .padding()
                }
                .tint(.white)
            }
    }
}
