//
//  MultiStepForm.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI

enum FieldState {
    case idle
    case loading
    case success
    case error
}

enum StepType {
    case inputField(placeholder: String, keyboardType: UIKeyboardType)
    case button(title: String, icon: String)
}

public struct FormStep: Identifiable {
    public let id = UUID()
    let icon: String
    let title: String
    let description: String
    
    let type: StepType
    let gradient: (Color, Color, Color)
    
    let onSubmit: (String) async throws -> Void
    var state: FieldState = .idle
    
    var answer: String = ""
}

struct MultiStepForm: View {
    @State var steps: [FormStep]
    @State private var currentStep = 0
    
    let completionStep: CompletionStep
    
    @Binding var gradient: (Color, Color, Color)
    @FocusState.Binding var keyboardShown: Bool
    
    private var hasFinishedForm: Bool {
        currentStep >= steps.count
    }
    
    var body: some View {
        VStack (spacing: 64) {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(steps, id: \.id) { step in
                    Step(
                        icon: step.icon,
                        iconColour: step.gradient.0,
                        title: step.title,
                        description: step.description,
                        isExpanded: !hasFinishedForm && step.id == steps[currentStep].id
                    )
                }
                
                ZStack {
                    if hasFinishedForm {
                        CompletionStep(
                            title: completionStep.title,
                            description: completionStep.description,
                            completionTitle: completionStep.completionTitle,
                            completionDescription: completionStep.completionDescription,
                            onSubmit: completionStep.onSubmit,
                            onComplete: completionStep.onComplete
                        )
                        .transition(.offset(y: 40).combined(with: .opacity))
                    }
                }
                .animation(.default.delay(0.4), value: hasFinishedForm)
            }
            
            if !hasFinishedForm {
                switch steps[currentStep].type {
                case .button(let title, let icon):
                    ContinueButton(
                        title: title,
                        icon: icon,
                        action: submitCurrentStep,
                        state: steps[currentStep].state
                    )
                    .animation(.none, value: currentStep)
                case .inputField(let placeholder, let keyboardType):
                    InputField(
                        label: placeholder,
                        value: $steps[currentStep].answer,
                        keyboardType: keyboardType,
                        state: steps[currentStep].state,
                        action: submitCurrentStep,
                        keyboardShown: $keyboardShown
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: hasFinishedForm ? .center : .bottomLeading)
        .padding(42)
    }
    
    private func submitCurrentStep() {
        guard currentStep >= 0 && currentStep < steps.count else { return }
        
        let submitAction = steps[currentStep].onSubmit
        let answer = steps[currentStep].answer
        
        steps[currentStep].state = .loading
        keyboardShown = false
        
        let isLastStep = currentStep == steps.count - 1
        
        Task {
            do {
                try await submitAction(answer)
                
                steps[currentStep].state = .success
                
                if isLastStep {
                    gradient = (.clear, .clear, .clear)
                }
                
                withAnimation(.smooth(duration: 0.5)) {
                    currentStep += 1
                    
                    if !isLastStep {
                        gradient = steps[currentStep].gradient
                    }
                }
            } catch {
                steps[currentStep].state = .error
            }
        }
    }
}

#Preview {
    @Previewable @FocusState var keyboardShown: Bool
    @Previewable @State var gradient: (Color, Color, Color) = (.blue, .blue, .blue)
    
    MultiStepForm(
        steps: [
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
        completionStep: CompletionStep(
            title: "Setting up your wallet",
            description: "Hold tight while we're getting your wallet ready",
            completionTitle: "Your wallet is ready",
            completionDescription: "You now have a safe place for your money",
            onSubmit: {
                print("Submitting")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }, onComplete: {
                print("Completed")
            }
        ),
        gradient: $gradient,
        keyboardShown: $keyboardShown,
    )
}
