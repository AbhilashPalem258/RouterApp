//
//  BiometricAuthScreen.swift
//  iOS
//
//  Created by Abhilash Palem on 31/03/24.
//

import SwiftUI

private enum AuthType {
    case biometric
    case pin
    case both
}

struct BiometricAuthScreen: View {
    private let authType: AuthType = .biometric
    @State private var showPinView = false
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
                    withAnimation(.snappy(duration: 5)) {
                        showPinView = true
                    }
                } label: {
                    Text("Enter Pin")
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(width: size.width, height: size.height)
            .overlay {
                if showPinView {
                    EnterPinView(showView: $showPinView)
                        .frame(width: size.width, height: size.height)
                        .transition(.offset(y: size.height + 100))
                }
            }
        }
    }
}

@Observable
private class EnterPinViewModel {
    let shouldShowBackButton: Bool = true
    let pin: String = "1234"
    var enteredPin: Array<String> = []
    var triggerErrorAnimation = false
    var successfulLogin: (() -> ())? = nil
    
    func validatedPin() {
        if enteredPin.count == pin.count {
            if String(enteredPin.joined()) == pin {
                successfulLogin?()
            } else {
                enteredPin = []
                triggerErrorAnimation.toggle()
            }
        }
    }
}

fileprivate struct EnterPinView: View {
    
    var vm = EnterPinViewModel()
    @Binding var showView: Bool
    
    private var backBtn: some View {
        Button {
            showView = false
        } label: {
            Image(systemName: "arrow.backward")
                .font(.title2.bold())
                .padding(15)
                .contentShape(.rect)
        }
    }
    
    private var headerView: some View {
        Text("Enter Pin")
            .font(.title.bold())
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                backBtn
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
    }
    
    private var pinInputView: some View {
        HStack {
            ForEach(0..<vm.pin.count, id: \.self) { index in
                Rectangle()
                    .frame(width: 50, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .overlay {
                        Text(
                            (index < vm.enteredPin.count) ?
                            vm.enteredPin[index] : ""
                        )
                        .foregroundStyle(.black)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                    }
            }
        }
        .keyframeAnimator(initialValue: CGFloat.zero, trigger: vm.triggerErrorAnimation) { content, xOffset in
            content
                .offset(x: xOffset)
        } keyframes: { _ in
            KeyframeTrack {
                CubicKeyframe(30, duration: 0.07)
                CubicKeyframe(-30, duration: 0.07)
                CubicKeyframe(20, duration: 0.07)
                CubicKeyframe(-20, duration: 0.07)
                CubicKeyframe(0, duration: 0.07)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                
            } label: {
                Text("Forgot pin?")
                    .font(.caption.bold())
                    .offset(y: 30)
            }
        }
    }
    
    private var KeypadView: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
            ForEach(1..<10, id:\.self) { index in
                Button {
                    if vm.enteredPin.count < vm.pin.count {
                        vm.enteredPin.append("\(index)")
                    }
                } label: {
                    Text("\(index)")
                        .keypadItem()
                }
            }
            
            Button {
                if !vm.enteredPin.isEmpty {
                    vm.enteredPin.removeLast()
                }
            } label: {
                Image(systemName: "delete.left")
                    .keypadItem()
            }
            
            Button {
                if vm.enteredPin.count < vm.pin.count {
                    vm.enteredPin.append("0")
                }
            } label: {
                Text("0")
                    .keypadItem()
            }
        }
    }
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .overlay {
                VStack {
                    headerView
                    Spacer()
                    pinInputView
                    Spacer()
                    KeypadView
                }
                .foregroundStyle(.white)
            }
            .onChange(of: vm.enteredPin, initial: false) { oldValue, newValue in
                vm.validatedPin()
            }
    }
}

#Preview {
    BiometricAuthScreen()
}

private extension View {
    func keypadItem() -> some View {
        self.modifier(KeypadItem())
    }
}

private struct KeypadItem: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title.bold())
            .padding(.vertical, 10)
    }
}
