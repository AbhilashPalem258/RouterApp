//
//  BiometricAuthScreen.swift
//  iOS
//
//  Created by Abhilash Palem on 31/03/24.
//

import SwiftUI
import Combine

@Observable
final class BiometricAuthViewModel {
    @ObservationIgnored
    let enterPinSelected = PassthroughSubject<Void, Never>()
}

struct BiometricAuthScreen: View {
    
    @State private var viewModel: BiometricAuthViewModel
    init(viewModel: BiometricAuthViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            VStack {
                Button {
                    
                } label: {
                    Text("face ID")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    viewModel.enterPinSelected.send()
                } label: {
                    Text("Enter Pin")
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(width: size.width, height: size.height)
        }
    }
}



#Preview {
    BiometricAuthScreen(viewModel: .init())
}
