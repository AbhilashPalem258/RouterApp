//
//  SecondLoginScreen.swift
//  iOS
//
//  Created by Abhilash Palem on 01/04/24.
//

import SwiftUI

fileprivate extension View {
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
}

fileprivate extension Binding where Value == String {
    func limit(to length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

enum LoginUIKit {
    
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
        @State private var showBottomSheet: Bool = false
        
        @State private var bottomSheetHeight: CGFloat = 0.0
        @State private var forgotPasswordViewHeight: CGFloat = 0.0
        @State private var resetPasswordViewHeight: CGFloat = 0.0
        
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
                    showBottomSheet = true
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
        
        var bottomView: some View {
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack {
                        ForgotPasswordView(viewHeight: $forgotPasswordViewHeight, sheetHeight: $bottomSheetHeight)
                            .containerRelativeFrame(.horizontal)
                            .id("ForgotPasswordView")
                        
                        ResetPasswordView(
                            prevViewHeight: forgotPasswordViewHeight,
                            viewHeight: $forgotPasswordViewHeight, sheetHeight: $bottomSheetHeight
                        )
                            .containerRelativeFrame(.horizontal)
                            .id("ResetPasswordView")
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
//            .presentationDetents(bottomSheetHeight == 0.0 ? [.height(0.0)] : [.height(bottomSheetHeight)])
            .presentationDetents([.medium])
            .presentationCornerRadius(20)
            .onChange(of: bottomSheetHeight) { oldValue, newValue in
                print("bottomSheetHeight: \(newValue)")
            }
        }
        
        var body: some View {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .overlay {
                    loginCard
                }
                .sheet(isPresented: $showBottomSheet) {
                    bottomSheetHeight = 0.0
                    forgotPasswordViewHeight = 0.0
                    resetPasswordViewHeight = 0.0
                } content: {
                    bottomView
                }
        }
    }
    
    struct ForgotPasswordView: View {
        
        @State private var userName: String = ""
        @Binding var viewHeight: CGFloat
        @Binding var sheetHeight: CGFloat
        
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
                        
                        InputField(icon: "at", iconTint: .gray, placeholder: "Email ID", text: $userName)
                        
                        GradientButton(title: "Send Link") {
                            print("Login Tapped")
                        }
                        .hSpacing(alignment: .trailing)
                        
                        Spacer()
                    }
                    .tint(.black)
                    .hSpacing(alignment: .leading)
                    .padding(.horizontal, 16)
                    .onheightChange { value in
                        print("Forgot ViewHeight: \(viewHeight)")
                        viewHeight = value
                        sheetHeight = value
                    }
                }
        }
    }
    
    struct EnterPinField: View {
        let numberOfInput: Int
        @Binding var input: String
        @FocusState private var isFocused: Bool
        var body: some View {
            HStack {
                ForEach(0..<numberOfInput, id: \.self) { index in
                    singleEntryField(index: index)
                }
            }
            .frame(height: 60)
            .background {
                TextField("", text: $input.limit(to: numberOfInput))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .focused($isFocused)
            }
            .contentShape(.rect)
            .onTapGesture {
                print("Enter Pin tapped")
                isFocused = true
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button {
                        isFocused = false
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .foregroundStyle(.black)
                    }
                    .hSpacing(alignment: .trailing)
                }
            }
        }
        
        func singleEntryField(index: Int) -> some View {
            RoundedRectangle(cornerRadius: 8.0)
                .fill(.white)
                .overlay {
                    if index < input.count {
                        let startIndex = input.startIndex
                        let index = input.index(startIndex, offsetBy: index)
                        Text(String(input[index]))
                            .font(.title.bold())
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8.0)
                        .stroke(.gray, lineWidth: 0.5)
                }
                .allowsHitTesting(false)
        }
    }
    
    struct VerifyOTPView: View {
        
        @State private var otpText: String = ""
        
        var body: some View {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .overlay {
                    VStack(alignment: .leading) {
                        Text("Verify OTP")
                            .font(.title.bold())
                        
                        EnterPinField(numberOfInput: 6, input: $otpText)
                        
                        Button {
                            
                        } label: {
                            Text("Verify")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(.blue, in: .rect(cornerRadius: 8.0))
                        }
                        .disableWithOpacity(otpText.count < 6)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .padding()
                }
        }
    }
    
    struct ResetPasswordView: View {
        @State private var password: String = ""
        @State private var confirmPassword: String = ""
        
        var prevViewHeight: CGFloat
        @Binding var viewHeight: CGFloat
        @Binding var sheetHeight: CGFloat
        
        @State private var progress: CGFloat = 0.0
        
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
                                                    
                            InputField(icon: "lock", iconTint: .gray, placeholder: "Password", text: $password)
                            
                            InputField(icon: "lock", iconTint: .gray, placeholder: "Confirm Password", text: $confirmPassword)


                            
                            GradientButton(title: "Reset Password") {
                                print("Reset Tapped")
                            }
                            .hSpacing(alignment: .trailing)
                            
                            Spacer()
                        }
                        .tint(.black)
                        .hSpacing(alignment: .leading)
                        .padding(.horizontal, 16)
                        .onResetHeightChange { value in
                            viewHeight = value
                            print("Reset ViewHeight: \(viewHeight)")
                            let diff = viewHeight - prevViewHeight
                            sheetHeight = prevViewHeight + (diff * progress)
                        }
                    }
                    .onMinXChange { value in
//                        print("ResetView minX: \(value)")
                        let diff = viewHeight - prevViewHeight
                        let truncatedMinX = min(size.width - value, size.width)
                        guard truncatedMinX > 0 else { return }
                        progress = truncatedMinX / size.width
//                        print("""
//                        *****************************************************
//                        ResetView progress: \(progress),
//                        viewHeight: \(viewHeight),
//                        prevViewHeight: \(prevViewHeight),
//                        height: \(prevViewHeight + (progress * diff)),
//                        *******************************************************
//                        """)
                        sheetHeight = prevViewHeight + (progress * diff)
                    }
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
                    .offset(y: -2)
                
                VStack {
                    Group {
                        if isSecure {
                            SecureField(placeholder, text: $text)
                        } else {
                            TextField(placeholder, text: $text)
                        }
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
                .font(.title2.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background { Capsule().fill(.black.gradient) }
            }
            .tint(.white)
        }
    }
}
#Preview {
    LoginUIKit.VerifyOTPView()
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
