//
//  FirstAppIntroScreen.swift
//  iOS
//
//  Created by Abhilash Palem on 30/03/24.
//

import Foundation
import SwiftUI

private struct Intro: Identifiable {
    let id: UUID = .init()
    let text: String
    let textColor: Color
    let backgroundColor: Color
    var textOffset: CGFloat = 0.0
    var circleOffset: CGFloat = 0.0
}


@Observable
private class ViewModel {
    
    var activeIntro: Intro
    
    private var currentIndex: Int
    private var introCollection: [Intro]
    
    init() {
        let intros: [Intro] = [
            .init(text: "Whatever", textColor: Color(.color1), backgroundColor: Color(.color4)),
            .init(text: "Happens", textColor: Color(.color2), backgroundColor: Color(.color1)),
            .init(text: "Take", textColor: Color(.color3), backgroundColor: Color(.color2)),
            .init(text: "Responsibility", textColor: Color(.color4), backgroundColor: Color(.color3)),
        ]
        introCollection = intros
        activeIntro = intros[0]
        currentIndex = 0
    }
    
    func textSize(_ intro: Intro) -> CGFloat {
        NSString(string: intro.text).size(withAttributes: [
            .font: UIFont.preferredFont(forTextStyle: .largeTitle)
        ]).width
    }
    
    func changeItem() {
        currentIndex += 1
        let nextIndex = currentIndex % introCollection.count
        var nextItem = introCollection[nextIndex]
        nextItem.textOffset = -(textSize(nextItem)) - 20
        nextItem.circleOffset = (textSize(nextItem) / 2) + 20
        activeIntro = nextItem
    }
    
    func resetIntroPosition() {
        activeIntro.textOffset = 0.0
        activeIntro.circleOffset = 0.0
    }
}

struct FirstAppIntroScreen: View {
    
    private var vm: ViewModel = .init()
    
    private func walkthroughView(_ intro: Intro) -> some View {
        Rectangle()
            .fill(intro.backgroundColor)
            .overlay {
                Circle()
                    .fill(intro.textColor)
                    .frame(width: 38, height: 38)
                    .background(alignment: .leading) {
                        Capsule()
                            .fill(intro.backgroundColor)
                            .frame(width: vm.textSize(intro) + 20)
                    }
                    .background(alignment: .leading) {
                        Text(intro.text)
                            .font(.largeTitle)
                            .foregroundStyle(intro.textColor)
                            .frame(width: vm.textSize(intro))
                            .offset(x: 10)
                            .offset(x: intro.textOffset)
                    }
                    .offset(x: intro.circleOffset)
            }
    }
    
    private var bottomSheet: some View {
        VStack(spacing: 12) {
            Button {
                
            } label: {
                Label("Continue with Apple", systemImage: "applelogo")
                    .modifier(LoginBtn(bgColor: .white))
            }
            .foregroundColor(.black)
            
            Button {
                
            } label: {
                Label("Continue with Phone", systemImage: "phone.fill")
                    .modifier(LoginBtn(bgColor: .button))
            }
            .foregroundColor(.white)
            
            Button {
                
            } label: {
                Label("Continue with Email", systemImage: "mail.fill")
                    .modifier(LoginBtn(bgColor: .button))
            }
            .foregroundColor(.white)
            
            
            Button {
                
            } label: {
                Label("Continue with Google", systemImage: "g.circle.fill")
                    .modifier(LoginBtn(bgColor: .button))
            }
            .foregroundColor(.white)
        }
        .padding(.top, 20)
        .padding(15)
        .background(.black, in: .rect(topLeadingRadius: 20, topTrailingRadius: 20))
        .padding(.top, -30)
    }
    
    var body: some View {
        GeometryReader{ proxy in
            let safeAreaInsets = proxy.safeAreaInsets
            
            VStack(spacing: 0) {
                walkthroughView(vm.activeIntro)
                bottomSheet
                    .padding(.bottom, safeAreaInsets.bottom)
                    .frame(maxWidth: 400)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    animate()
                }
            }
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
    
    func animate() {
        withAnimation(.snappy(duration: 1.0), completionCriteria: .removed) {
            vm.changeItem()
        } completion: {
            withAnimation(.snappy(duration: 1.0), completionCriteria: .logicallyComplete) {
                vm.resetIntroPosition()
            } completion: {
                animate()
            }
        }
    }
}

#Preview {
    FirstAppIntroScreen()
}

private struct LoginBtn: ViewModifier {
    let bgColor: Color
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(bgColor)
            .cornerRadius(10)
    }
}
