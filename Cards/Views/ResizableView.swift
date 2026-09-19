//
//  ResizableView.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct ResizableView: ViewModifier {
    @Binding var transform: Transform
    var viewScale: CGFloat = 1

    @State private var previousOffset: CGSize = .zero
    @State private var previousRotation: Angle = .zero
    @State private var scale: CGFloat = 1.0

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let scaledTranslation = CGSize(
                    width: value.translation.width / viewScale,
                    height: value.translation.height / viewScale
                )
                transform.offset = scaledTranslation + previousOffset
            }
            .onEnded { _ in
                previousOffset = transform.offset
            }
    }

    var rotationGesture: some Gesture {
        RotationGesture()
            .onChanged { rotation in
                transform.rotation += rotation - previousRotation
                previousRotation = rotation
            }
            .onEnded { _ in
                previousRotation = .zero
            }
    }

    var scaleGesture: some Gesture {
        MagnificationGesture()
            .onChanged { currentScale in
                self.scale = currentScale
            }
            .onEnded { finalScale in
                transform.size.width *= finalScale
                transform.size.height *= finalScale
                self.scale = 1.0
            }
    }

    func body(content: Content) -> some View {
        content
            .frame(
                width: transform.size.width * viewScale,
                height: transform.size.height * viewScale
            )
            .rotationEffect(transform.rotation)
            .scaleEffect(scale)
            .offset(transform.offset * viewScale)
            .gesture(dragGesture)
            .gesture(SimultaneousGesture(rotationGesture, scaleGesture))
            .onAppear {
                previousOffset = transform.offset
            }
    }
}

extension View {
    func resizableView(transform: Binding<Transform>, viewScale: CGFloat = 1) -> some View {
        modifier(ResizableView(transform: transform, viewScale: viewScale))
    }
}
