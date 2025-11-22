//
//  OnboardingFlow.swift
//  FuseAppOnboarding
//
//  Created by George on 05/11/2025.
//

import SwiftUI

struct OnboardingFlow: View {
    let title: String
    let description: String
    let logo: String
    var startGradient: (Color, Color, Color)?
    
    let carousel: [Carousel]
    let form: [FormStep]
    let completion: CompletionStep
    
    @FocusState private var keyboardShown: Bool
    @State private var showGradient = true
    
    @State private var phase = 0
    @State private var gradient: (Color, Color, Color) = (
        Color(red: 0.004, green: 0.373, blue: 1, opacity: 1),
        Color(red: 0, green: 0.875, blue: 1, opacity: 1),
        Color(red: 0.004, green: 0.678, blue: 1, opacity: 1)
    )
    
    var body: some View {
        ZStack {
            if showGradient {
                ZStack {
                    RadialGradient(
                        colors: [gradient.0, .clear],
                        center: phase > 0 ? .top : .bottom,
                        startRadius: phase > 0 ? 0 : 300,
                        endRadius: 500
                    )
                    .animation(.smooth.delay(0.65), value: phase > 0)
                    
                    RadialGradient(
                        colors: [gradient.1, .clear],
                        center: phase > 0 ? .top : .bottom,
                        startRadius: phase > 0 ? 50 : 200,
                        endRadius: 450
                    )
                    .animation(.smooth.delay(0.52), value: phase > 0)
                    
                    RadialGradient(
                        colors: [gradient.2, .clear],
                        center: phase > 0 ? .init(x: 0.5, y: -0.2) : .bottom,
                        startRadius: phase > 0 ? 0 : 80,
                        endRadius: 350
                    )
                    .animation(.smooth.delay(0.4), value: phase > 0)
                }
                .transition(.move(edge: .top))
            }
            
            VStack {
                if phase == 0 {
                    WelcomeScreen(
                        title: title,
                        description: description,
                        logo: logo,
                        carousel: carousel,
                        action: {
                            withAnimation(.smooth(duration: 0.7)) {
                                phase = 1
                                
                                if let formStartGradient = form.first?.gradient {
                                    gradient = formStartGradient
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    withAnimation(.smooth) {
                                        phase = 2
                                    }
                                }
                            }
                        }
                    )
                    .transition(
                        .opacity
                            .combined(with: .offset(y: 20))
                    )
                }
                
                if phase == 2 {
                    MultiStepForm(
                        steps: form,
                        completionStep: completion,
                        gradient: $gradient,
                        keyboardShown: $keyboardShown,
                    )
                    .transition(
                        .opacity
                            .combined(with: .offset(y: 20))
                    )
                }
            }
        }
        .background(.white)
        .ignoresSafeArea(.container)
        .onAppear {
            if let startGradient {
                gradient = startGradient
            }
        }
        .onChange(of: keyboardShown) { _, newValue in
            withAnimation(.smooth) {
                showGradient = !newValue
            }
        }
    }
}

#Preview {
    OnboardingFlow(
        title: "A demo,\nupgraded",
        description: "Save, earn and invest\nwith stablecons and digital assets",
        logo: "logo",
        startGradient: (.blue, .cyan, .blue),
        carousel: [
            .init(text: "Pay", image: "pay"),
            .init(text: "Invest", image: "invest"),
            .init(text: "Spend", image: "spend"),
            .init(text: "Earn", image: "earn"),
            .init(text: "Save", image: "save"),
        ],
        form: [
            FormStep(
                icon: "faceid",
                title: "Device Key",
                description: "Your Device Key is protected by biometric verification – encrypted and stored on your phone.",
                type: .button(title: "Create Device Key", icon: "faceid"),
                gradient: (.blue, .blue, .blue),
                onSubmit: { answer in
                    try await Task.sleep(nanoseconds: 500_000_000)
                }
            ),
            FormStep(
                icon: "cloud.fill",
                title: "2FA Key",
                description: "Your 2FA Key adds a second layer of protection – encrypted, and stored in iCloud.",
                type: .button(title: "Create 2FA Key", icon: "cloud.fill"),
                gradient: (.orange, .orange, .orange),
                onSubmit: { answer in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                }
            ),
            FormStep(
                icon: "envelope.fill",
                title: "Recovery Key",
                description: "Your Recovery Key helps you regain access to Fuse if you lose your phone.",
                type: .inputField(placeholder: "Enter your email", keyboardType: .emailAddress),
                gradient: (.purple, .purple, .purple),
                onSubmit: { answer in
                    print(answer)
                }
            )
        ],
        completion: CompletionStep(
            title: "Setting up your wallet",
            description: "Hold tight while we're getting your wallet ready",
            completionTitle: "Your wallet is ready",
            completionDescription: "You now have a safe place for your money",
            onSubmit: {
                print("Submitting")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            },
            onComplete: {
                print("Completed")
            }
        )
    )
}
