//
//  FirstLoginScreen.swift
//  iOS
//
//  Created by Abhilash Palem on 30/03/24.
//
import SwiftUI
import Foundation
import Combine

@Observable
final class GlassBGLoginViewModel {
    var username: String = ""
    var password: String = ""
    
    @ObservationIgnored
    let backButtonClicked = PassthroughSubject<Void, Never>()
}

struct GlassBGLoginScreen: View {
    
    @State private var viewModel: GlassBGLoginViewModel
    
    init(viewModel: GlassBGLoginViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    private func inputField(title: String, placeholder: String, text: Binding<String>, isSecure: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout.bold())
                
            Group {
                if isSecure {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.white.opacity(0.12), in: .rect(cornerRadius: 8))
        }
    }
    
    private var otherOptionsView: some View {
        HStack {
            Button {
                
            } label: {
                Label("Email", systemImage: "envelope.fill")
                    .modifier(LoginOptionButton())
            }
            
            Button {
                
            } label: {
                Label("Apple", systemImage: "applelogo")
                    .modifier(LoginOptionButton())
            }
        }
    }
    
    private var loginCardView: some View {
        VStack(spacing: 12) {
            Text("Welcome!")
                .font(.title.bold())
            
            inputField(title: "Username", placeholder: "Username", text: $viewModel.username)
            
            inputField(title: "Password", placeholder: "Password", text: $viewModel.password, isSecure: true)
            
            Button {
                
            } label: {
                Text("Login")
                    .font(.title3.bold())
                    .foregroundStyle(.black)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(.white, in: .rect(cornerRadius: 8))
            }
            .padding(.vertical, 20)
            
            otherOptionsView
        }
        .padding(.top, 35)
        .padding(.bottom, 25)
        .padding(.horizontal, 30)
        .clipShape(.rect(cornerRadius: 10))
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(.white.opacity(0.2), style: .init(lineWidth: 1.0))
        }
        .background {
            TransparentBlurView(removeAllFilters: true)
                .blur(radius: 9, opaque: true)
                .background(.white.opacity(0.05))
        }
        .padding(.horizontal, 30)
        .background {
            Circle()
                .fill(
                    LinearGradient(colors: [.gradient1, .gradient2], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 128, height: 128)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: -25, y: -55)
        }
        .background {
            Circle()
                .fill(
                    LinearGradient(colors: [.gradient3, .gradient4], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 128, height: 128)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: 25, y: 55)
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(.black)
            .overlay {
                loginCardView
            }
            .overlay(alignment: .topLeading) {
                Button {
                    viewModel.backButtonClicked.send()
                } label: {
                    Image(systemName: "arrow.backward")
                        .font(.title2.bold())
                        .padding()
                }
                .tint(.white)
            }
    }
}

#Preview {
    GlassBGLoginScreen(viewModel: .init())
}

struct LoginOptionButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.callout.bold())
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background {
                TransparentBlurView(removeAllFilters: true)
                    .background(.white.opacity(0.1))
            }
            .clipShape(.rect(cornerRadius: 8))
    }
}

private struct TransparentBlurView: UIViewRepresentable {
    let removeAllFilters: Bool
    func makeUIView(context: Context) -> UIVisualEffectView {
        TransparentVisualEffectView(removeAllFilters: removeAllFilters)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

private class TransparentVisualEffectView: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .light))
        
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0.0
        }
        
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
