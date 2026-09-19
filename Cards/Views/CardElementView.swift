//
//  CardElementView.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct ImageElementView: View {
    let element: ImageElement

    var body: some View {
        element.image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clip(element: element)
    }
}

private extension View {
    @ViewBuilder
    func clip(element: ImageElement) -> some View {
        if let frameIndex = element.frameIndex, frameIndex < Shapes.shapes.count {
            let shape = Shapes.shapes[frameIndex]
            self.clipShape(shape)
                .contentShape(shape)
        } else {
            self
        }
    }
}

struct TextElementView: View {
    let element: TextElement

    var body: some View {
        if !element.text.isEmpty {
            Text(element.text)
                .font(.custom(element.textFont, size: 200))
                .foregroundColor(element.textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.01)
        }
    }
}

struct CardElementView: View {
    let element: CardElement

    var body: some View {
        if let imageElement = element as? ImageElement {
            ImageElementView(element: imageElement)
        } else if let textElement = element as? TextElement {
            TextElementView(element: textElement)
        }
    }
}
