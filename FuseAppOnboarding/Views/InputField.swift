//
//  InputField.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI

struct InputField: View {
    let label: String
    @Binding var value: String
    let keyboardType: UIKeyboardType
    var state: FieldState
    let action: () -> Void
    
    @FocusState.Binding var keyboardShown: Bool
    
    private var isValid: Bool {
        return !value.isEmpty
    }
    
    private var isDisabled: Bool {
        state == .success || state == .loading
    }
    
    var body: some View {
        HStack {
            TextField(label, text: $value, prompt: Text(label).foregroundStyle(.black.opacity(0.4)))
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.black.opacity(state == .success ? 0.4 : 1))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(keyboardType)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .focused($keyboardShown)
                .disabled(state == .success || state == .loading)
            
            Button {
                if state != .loading {
                    action()
                }
            } label: {
                switch state {
                case .loading:
                    ProgressView()
                        .tint(.white)
                default:
                    Image(systemName: "arrow.right")
                }
            }
            .font(.system(size: 24, weight: .bold))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .foregroundStyle(.white)
            .background(.black.opacity((isValid && state != .success) ? 1 : 0.2))
            .clipShape(RoundedRectangle(cornerRadius: .infinity))
            .disabled(!isValid || state == .success || state == .loading)
        }
        .padding(.leading, 24)
        .padding(.trailing, 16)
        .padding(.vertical, 12)
        .overlay {
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(.black.opacity(0.1), lineWidth: 1)
        }
    }
}

#Preview {
    @Previewable @FocusState var keyboardShown: Bool
    @Previewable @State var value = ""
    @Previewable @State var state: FieldState = .idle
    
    InputField(
        label: "Enter your email",
        value: $value,
        keyboardType: .emailAddress,
        state: state,
        action: {
            Task {
                state = .loading
                try await Task.sleep(for: .seconds(1))
                state = .success
            }
        },
        keyboardShown: $keyboardShown
    )
}
