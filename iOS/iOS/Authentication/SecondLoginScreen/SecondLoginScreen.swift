//
//  SecondLoginScreen.swift
//  iOS
//
//  Created by Abhilash Palem on 01/04/24.
//

import SwiftUI

enum LoginKit {
    
    struct AuthenicationView: View {
        @State private var showSignUp: Bool = false
        var body: some View {
            NavigationStack {
                LoginScreen(showSignup: $showSignUp)
                    .navigationDestination(isPresented: $showSignUp) {
                        SignUpScreen(showSignup: $showSignUp)
                            .toolbar(.hidden, for: .navigationBar)
                    }
            }
            .overlay(alignment: showSignUp ? .topTrailing : .topLeading) {
                Circle()
                    .fill(.black)
                    .frame(width: 200, height: 200)
                    .blur(radius: 8)
                    .offset(x: showSignUp ? 90 : -90, y: -90)
                    .animation(.snappy, value: showSignUp)
            }
        }
    }
    
    struct LoginScreen: View {
        
        @Binding var showSignup: Bool
        @State private var userName: String = ""
        @State private var password: String = ""
        
        var loginCard: some View {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()

                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("Please sign in to continue")
                
                InputField(icon: "at", iconTint: .gray, placeholder: "Email ID", text: $userName)

                InputField(icon: "lock", iconTint: .gray, placeholder: "Password", text: $password, isSecure: true)
                
                Button {
                } label: {
                    Text("Forgot Password?")
                        .font(.callout.bold())
                        .padding(4)
                }
                .hSpacing(alignment: .trailing)
                
                GradientButton(title: "Login") {
                    print("Login Tapped")
                }
                .hSpacing(alignment: .trailing)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .font(.headline)
                        .foregroundStyle(.gray)
                    
                    Button {
                        showSignup = true
                    } label: {
                        Text("Sign Up")
                            .font(.callout.bold())
                            .padding(4)
                    }
                }
                .hSpacing()
            }
            .tint(.black)
            .hSpacing(alignment: .leading)
            .padding(.horizontal, 16)
        }
        
        var body: some View {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .overlay {
                    loginCard
                }
        }
    }
    
    struct SignUpScreen: View {
        @Binding var showSignup: Bool
        @State private var userName: String = ""
        @State private var password: String = ""
        
        var body: some View {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .overlay {
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer()

                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        
                        Text("Please sign up to continue")
                        
                        InputField(icon: "at", iconTint: .gray, placeholder: "Email ID", text: $userName)
                        
                        InputField(icon: "person", iconTint: .gray, placeholder: "Full Name", text: $userName)

                        InputField(icon: "lock", iconTint: .gray, placeholder: "Password", text: $password, isSecure: true)

                        GradientButton(title: "Login") {
                            print("Login Tapped")
                        }
                        .hSpacing(alignment: .trailing)
                        
                        Spacer()
                        
                        HStack {
                            Text("Already have an account?")
                                .font(.headline)
                                .foregroundStyle(.gray)
                            
                            Button {
                                showSignup = false
                            } label: {
                                Text("Login")
                                    .font(.callout.bold())
                                    .padding(4)
                            }
                        }
                        .hSpacing()
                    }
                    .tint(.black)
                    .hSpacing(alignment: .leading)
                    .padding(.horizontal, 16)
                }
        }
    }
    
    struct InputField: View {
        
        let icon: String
        let iconTint: Color
        let placeholder: String
        @Binding var text: String
        var isSecure: Bool = false
        
        @State private var showSecureText: Bool = false
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(iconTint)
                    .offset(y: -6)
                
                VStack {
                    Group {
                        if isSecure {
                            SecureField("", text: $text)
                        } else {
                            TextField("", text: $text)
                        }
                    }
                    .placeholder(when: text.isEmpty) {
                        Text(placeholder).foregroundColor(.gray)
                    }
                    .overlay(alignment: .trailing) {
                        if isSecure && !text.isEmpty {
                            Image(systemName: showSecureText ? "eye.slash" : "eye")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showSecureText.toggle()
                                }
                        }
                    }
                    
                    Divider()
                }
            }
            .padding()
        }
    }
    
    struct GradientButton: View {
        let title: String
        let action: () -> Void
        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Text(title)
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.white)
                .font(.title3.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background { Capsule().fill(.black.gradient) }
            }
            .tint(.white)
        }
    }
}
#Preview {
    LoginKit.VerifyOTPView(viewModel: .init())
}

private struct minXKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct heightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct ResetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private extension View {
    func onheightChange(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                let size = proxy.size
                
                Color.clear
                    .preference(key: heightKey.self, value: size.height)
                    .onPreferenceChange(heightKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
    
    func onResetHeightChange(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                let size = proxy.size
                
                Color.clear
                    .preference(key: ResetHeightKey.self, value: size.height)
                    .onPreferenceChange(ResetHeightKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
    
    func onMinXChange(completion: @escaping (CGFloat) -> Void) -> some View {
        overlay {
            GeometryReader { proxy in
                let xVal = proxy.frame(in: .scrollView).minX
                
                Color.clear
                    .preference(key: minXKey.self, value: xVal)
                    .onPreferenceChange(minXKey.self) { value in
                        completion(value)
                    }
            }
        }
    }
}
