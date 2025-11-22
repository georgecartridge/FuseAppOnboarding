//
//  CompletionStep.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI

struct CompletionStep: View {
    let title: String
    let description: String
    
    let completionTitle: String
    let completionDescription: String
    
    let onSubmit: () async -> Void
    let onComplete: () -> Void
    
    @State private var isCompleted = false
    @State private var isInProgress = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle.dashed")
                .id(isCompleted)
                .rotationEffect(.degrees(isCompleted ? 0 : isInProgress ? 360 : 0))
                .font(.system(size: 24))
                .foregroundStyle(isCompleted ? .green : .purple)
                .transition(.scale)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(isCompleted ? completionTitle : title)
                    .id(isCompleted)
                    .font(.system(size: 24))
                    .bold()
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(
                        .asymmetric(
                            insertion: .offset(y: 30).combined(with: .opacity),
                            removal: .opacity
                        )
                    )
                
                Text(isCompleted ? completionDescription : description)
                    .id(isCompleted)
                    .foregroundStyle(.black.opacity(0.3))
                    .fontWeight(.medium)
                    .transition(
                        .asymmetric(
                            insertion: .offset(y: 30).combined(with: .opacity),
                            removal: .opacity
                        )
                    )
            }
            .drawingGroup()
        }
        .onAppear {
            withAnimation(.linear(duration: 1).speed(0.3).repeatForever(autoreverses: false)) {
                isInProgress = true
            }
            
            Task {
                await onSubmit()
                
                withAnimation(.bouncy(duration: 1)) {
                    isCompleted = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading) {
        CompletionStep(
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
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
}
