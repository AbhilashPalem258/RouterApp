//
//  EnterPinView.swift
//  iOS
//
//  Created by Abhilash Palem on 07/04/24.
//
import SwiftUI
import Foundation
import Combine

@Observable
final class EnterPinViewModel {
    let shouldShowBackButton: Bool = true
    let pin: String = "1234"
    var enteredPin: Array<String> = []
    var triggerErrorAnimation = false
    
    @ObservationIgnored
    let successfulLogin = PassthroughSubject<Void, Never>()
    
    @ObservationIgnored
    let backPressed = PassthroughSubject<Void, Never>()
    
    @ObservationIgnored
    let forgotPinClick = PassthroughSubject<Void, Never>()
    
    func validatedPin() {
        if enteredPin.count == pin.count {
            if String(enteredPin.joined()) == pin {
                successfulLogin.send()
            } else {
                enteredPin = []
                triggerErrorAnimation.toggle()
            }
        }
    }
}
 
struct EnterPinView: View {
    
    @State private var viewModel: EnterPinViewModel
    init(viewModel: EnterPinViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    private var backBtn: some View {
        Button {
            viewModel.backPressed.send()
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
            ForEach(0..<viewModel.pin.count, id: \.self) { index in
                Rectangle()
                    .frame(width: 50, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    .overlay {
                        Text(
                            (index < viewModel.enteredPin.count) ?
                            viewModel.enteredPin[index] : ""
                        )
                        .foregroundStyle(.black)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                    }
            }
        }
        .keyframeAnimator(initialValue: CGFloat.zero, trigger: viewModel.triggerErrorAnimation) { content, xOffset in
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
                viewModel.forgotPinClick.send()
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
                    if viewModel.enteredPin.count < viewModel.pin.count {
                        viewModel.enteredPin.append("\(index)")
                    }
                } label: {
                    Text("\(index)")
                        .keypadItem()
                }
            }
            
            Button {
                if !viewModel.enteredPin.isEmpty {
                    viewModel.enteredPin.removeLast()
                }
            } label: {
                Image(systemName: "delete.left")
                    .keypadItem()
            }
            
            Button {
                if viewModel.enteredPin.count < viewModel.pin.count {
                    viewModel.enteredPin.append("0")
                }
            } label: {
                Text("0")
                    .keypadItem()
            }
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(.black)
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
            .onChange(of: viewModel.enteredPin, initial: false) { oldValue, newValue in
                viewModel.validatedPin()
            }
    }
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
