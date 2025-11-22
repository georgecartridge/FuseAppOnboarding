//
//  ContentView.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        OnboardingFlow(
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
                        try await Task.sleep(nanoseconds: 1_000_000_000)
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
}

#Preview {
    ContentView()
}
