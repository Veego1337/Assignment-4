//
//  CardDetailView.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject var store: CardStore
    @Binding var card: Card
    var viewScale: CGFloat = 1

    func isSelected(_ element: CardElement) -> Bool {
        store.selectedElement?.id == element.id
    }

    var body: some View {
        card.backgroundColor
            .onTapGesture {
                store.selectedElement = nil
            }
            .overlay(
                ForEach(0..<card.elements.count, id: \.self) { index in
                    let element = card.elements[index]
                    CardElementView(element: element)
                        .elementContextMenu(
                            card: $card,
                            element: Binding(
                                get: { card.elements[index] },
                                set: { card.elements[index] = $0 }
                            )
                        )
                        .selectionOutline(element: element, isSelected: isSelected(element))
                        .resizableView(
                            transform: Binding(
                                get: { card.elements[index].transform },
                                set: { card.elements[index].transform = $0 }
                            ),
                            viewScale: viewScale
                        )
                        .onTapGesture {
                            store.selectedElement = element
                        }
                }
            )
            .clipped()
            .onDisappear {
                store.selectedElement = nil
            }
    }
}

private extension View {
    @ViewBuilder
    func selectionOutline(element: CardElement, isSelected: Bool) -> some View {
        if isSelected {
            if let imageElem = element as? ImageElement,
               let frameIndex = imageElem.frameIndex,
               frameIndex < Shapes.shapes.count {
                self.overlay(
                    Shapes.shapes[frameIndex]
                        .stroke(Settings.borderColor, lineWidth: Settings.borderWidth)
                )
            } else {
                self.border(Settings.borderColor, width: Settings.borderWidth)
            }
        } else {
            self
        }
    }
}
