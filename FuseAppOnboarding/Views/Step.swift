//
//  Step.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI

struct Step: View {
    let icon: String
    let iconColour: Color
    let title: String
    let description: String
    
    var isExpanded: Bool
    
    var body: some View {
        let layout = isExpanded
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
            : AnyLayout(HStackLayout(spacing: 24))
        
        layout {
            Group {
                Image(systemName: icon)
                    .font(.system(size: isExpanded ? 32 : 20))
                    .bold()
                    .foregroundStyle(isExpanded ? iconColour : .gray)
                
                Text(title)
                    .font(.system(size: isExpanded ? 42 : 24))
                    .bold()
                    .foregroundStyle(isExpanded ? .black : .gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .drawingGroup()
            
            if isExpanded {
                Text(description)
                    .foregroundStyle(.black.opacity(0.3))
                    .fontWeight(.medium)
                    .transition(
                        .asymmetric(
                            insertion: .offset(y: 30).combined(with: .opacity),
                            removal: .offset(y: -60).combined(with: .opacity)
                        )
                        .animation(.smooth(duration: 0.2))
                    )
            }
        }
    }
}

#Preview {
    @Previewable @State var selected = 0
    
    var steps = [0, 1, 2]
    
    var e = Array(steps.enumerated())
    
    VStack(spacing: 64) {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(e, id: \.offset) { index, elem in
                Step(
                    icon: "faceid",
                    iconColour: .blue,
                    title: "Device Key",
                    description: "Your Device Key is protected by biometric verification – encrypted and stored on your phone.",
                    isExpanded: selected == index
                )
            }
        }
        
        Button("Toggle") {
            withAnimation(.smooth(duration: 1)) {
                selected = selected == 2 ? 0 : (selected + 1)
            }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    .padding(42)
}
