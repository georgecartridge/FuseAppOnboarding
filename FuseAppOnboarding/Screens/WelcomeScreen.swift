//
//  WelcomeScreen.swift
//  FuseAppOnboarding
//
//  Created by George on 05/11/2025.
//

import SwiftUI

struct WelcomeScreen: View {
    let title: String
    let description: String
    let logo: String
    
    let carousel: [Carousel]
    
    let action: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                TextCarousel(
                    items: carousel
                )
                .frame(height: 240)
            }
            .padding(.top, 120)
            .padding(.horizontal, 48)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            
            VStack(alignment: .leading, spacing: 20) {
                Image(logo)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 48))
                    .foregroundStyle(.white)
                    .frame(width: 50)
                
                Text(title)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                Text(description)
                    .foregroundStyle(.white.opacity(0.7))
                
                Button(action: {
                    action()
                }) {
                    Text("Continue")
                        .font(.headline)
                        .bold()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(.white)
                        .cornerRadius(.infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(42)
        }
    }
}

#Preview {
    WelcomeScreen(
        title: "A demo,\nupgraded",
        description: "Save, earn and invest\nwith stablecons and digital assets",
        logo: "logo",
        carousel: [
            .init(text: "Pay", image: "pay"),
            .init(text: "Invest", image: "invest"),
            .init(text: "Spend", image: "spend"),
            .init(text: "Earn", image: "earn"),
            .init(text: "Save", image: "save"),
        ],
        action: {
            print("Clicked continue")
        }
    )
    .background(.black.opacity(0.05))
}
