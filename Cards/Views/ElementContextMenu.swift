//
//  ElementContextMenu.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct ElementContextMenu: ViewModifier {
    @Binding var card: Card
    @Binding var element: CardElement

    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: {
                    if let textElem = element as? TextElement {
                        UIPasteboard.general.string = textElem.text
                    } else if let imgElem = element as? ImageElement, let img = imgElem.uiImage {
                        UIPasteboard.general.image = img
                    }
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }

                Button(action: {
                    card.remove(element)
                }) {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}

extension View {
    func elementContextMenu(
        card: Binding<Card>,
        element: Binding<CardElement>
    ) -> some View {
        modifier(ElementContextMenu(card: card, element: element))
    }
}
