//
//  ContinueButton.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI

struct ContinueButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    var state: FieldState
    
    var body: some View {
        Button(action: {
            if state != .loading {
                action()
            }
        }) {
            if state == .loading {
                ProgressView()
                    .tint(.white)
            } else {
                Image(systemName: icon)
            }
            
            Text(title)
                .font(.headline)
                .bold()
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(.black)
        .cornerRadius(.infinity)
    }
}

#Preview {
    @Previewable @State var state: FieldState = .idle
    
    ContinueButton(
        title: "Continue",
        icon: "faceid",
        action: {
            Task {
                print("Pressed continue")
                
                state = .loading
                
                try await Task.sleep(nanoseconds: 1_000_000_000)
                
                state = .success
            }
        },
        state: state
    )
}
