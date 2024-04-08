//
//  ResetPasswordView.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//
import SwiftUI
import Foundation
import Combine

extension LoginKit {
    
    @Observable
    final class ForgotPasswordViewModel {
        fileprivate var userName: String = ""
        
        @ObservationIgnored
        let onSubmitClick = PassthroughSubject<Void, Never>()
    }
    
    struct ForgotPasswordView: View {
        
        @State private var viewModel: ForgotPasswordViewModel
        init(viewModel: ForgotPasswordViewModel) {
            self._viewModel = State(wrappedValue: viewModel)
        }
        
        var body: some View {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .overlay {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Forgot Password?")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .padding(.top, 32)
                        
                        Text("Please enter your email ID so that we can send the reset link.")
                        
                        InputField(icon: "at", iconTint: .gray, placeholder: "Email ID", text: $viewModel.userName)
                        
                        GradientButton(title: "Send Link") {
                            print("Login Tapped")
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
