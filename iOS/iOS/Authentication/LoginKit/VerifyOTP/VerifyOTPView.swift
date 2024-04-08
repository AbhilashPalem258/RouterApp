//
//  VerifyOTPView.swift
//  iOS
//
//  Created by Abhilash Palem on 08/04/24.
//

import SwiftUI
import Combine

extension LoginKit {
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
                            .foregroundStyle(.white)
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
    
    @Observable
    final class VerifyOTPViewModel {
        fileprivate var otpText: String = ""
        
        @ObservationIgnored
        let onSubmitClick = PassthroughSubject<Void, Never>()
    }
    
    struct VerifyOTPView: View {
        
        @State private var viewModel: VerifyOTPViewModel
        init(viewModel: VerifyOTPViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            Rectangle()
                .fill(.white)
                .ignoresSafeArea()
                .overlay {
                    VStack(alignment: .leading) {
                        Text("Verify OTP")
                            .font(.title.bold())
                        
                        EnterPinField(numberOfInput: 6, input: $viewModel.otpText)
                        
                        Button {
                            viewModel.onSubmitClick.send()
                        } label: {
                            Text("Verify")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(.black, in: .rect(cornerRadius: 8.0))
                        }
                        .disableWithOpacity(viewModel.otpText.count < 6)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .foregroundStyle(.black)
                    .padding()
                }
        }
    }
}
