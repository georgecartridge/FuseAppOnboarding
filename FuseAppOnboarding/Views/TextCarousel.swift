//
//  TextCarousel.swift
//  FuseAppOnboarding
//
//  Created by George on 04/11/2025.
//

import SwiftUI
import Combine

struct Carousel: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let image: String
}

struct TextCarousel: View {
    @State var items: [Carousel]
    
    @State private var window: [Carousel] = []
    @State private var index = 0
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                ForEach(window) { item in
                    let isHighlighted = item.id == window[2].id
                    
                    HStack(spacing: 16) {
                        if isHighlighted {
                            Image(item.image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 38)
                                .font(.system(size: 48))
                                .transition(
                                    .move(edge: .leading).combined(with: .opacity).combined(with: .scale),
                                )
                        }
                    
                        Text(item.text)
                            .foregroundStyle(isHighlighted ? .black : .black.opacity(0.2))
                            .font(.system(size: 40, weight: .medium))
                    }
                    .drawingGroup()
                    .frame(height: proxy.size.height / 3)
                    .transaction { transaction in
                        if item.id == window.first?.id {
                            transaction.animation = nil
                        }
                    }
                }
            }
            .frame(
                height: proxy.size.height,
                alignment: .leading
            )
        }
        .mask(
            LinearGradient(
                gradient:
                    Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.3),
                        .init(color: .black, location: 0.7),
                        .init(color: .clear, location: 1)
                    ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onReceive(timer) { _ in
            withAnimation {
                window.removeLast()
                window.insert(Carousel(text: items[index].text, image: items[index].image), at: 0)
                index = ((index - 1) + items.count) % items.count
            }
        }
        .onAppear {
            for i in 0..<5 {
                let index = i % items.count
                let newItem = Carousel(text: items[index].text, image: items[index].image)
                
                window.append(newItem)
            }
            
            index = items.count - 1
        }
    }
}

#Preview {
    TextCarousel(
        items: [
            .init(text: "Pay", image: "pay"),
            .init(text: "Invest", image: "invest"),
            .init(text: "Spend", image: "spend"),
            .init(text: "Earn", image: "earn"),
            .init(text: "Save", image: "save"),
        ]
    )
    .frame(height: 240)
}
