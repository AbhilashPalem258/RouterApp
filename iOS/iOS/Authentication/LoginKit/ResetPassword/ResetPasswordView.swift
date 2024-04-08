//
//  ForgotPasswordView.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import SwiftUI
import Combine

extension LoginKit {
    
    @Observable
    final class ResetPasswordViewModel {
        fileprivate var password: String = ""
        fileprivate var confirmPassword: String = ""
        
        @ObservationIgnored
        let onSubmitClick = PassthroughSubject<Void, Never>()
    }
    
    struct ResetPasswordView: View {
        
        @State private var viewModel: ResetPasswordViewModel
        init(viewModel: ResetPasswordViewModel) {
            self._viewModel = State(wrappedValue: viewModel)
        }
                
        var body: some View {
            GeometryReader { proxy in
                let size = proxy.size
                
                Rectangle()
                    .fill(.white)
                    .ignoresSafeArea()
                    .overlay {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Reset Password")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .padding(.top, 32)
                                                    
                            InputField(icon: "lock", iconTint: .gray, placeholder: "Password", text: $viewModel.password)
                            
                            InputField(icon: "lock", iconTint: .gray, placeholder: "Confirm Password", text: $viewModel.confirmPassword)


                            
                            GradientButton(title: "Reset Password") {
                                print("Reset Tapped")
                                viewModel.onSubmitClick.send()
                            }
                            .hSpacing(alignment: .trailing)
                            
                            Spacer()
                        }
                        .tint(.black)
                        .foregroundStyle(.black)
                        .hSpacing(alignment: .leading)
                        .padding(.horizontal, 16)
                    }
            }
        }
    }

}
