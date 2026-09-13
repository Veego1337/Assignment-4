import SwiftUI

struct TransformModifier: ViewModifier {
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    @Binding var rotation: Angle
    
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureOffset: CGSize = .zero
    @GestureState private var gestureRotation: Angle = .zero
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale * gestureScale)
            .offset(x: offset.width + gestureOffset.width,
                    y: offset.height + gestureOffset.height)
            .rotationEffect(rotation + gestureRotation)
            .gesture(
                DragGesture()
                    .updating($gestureOffset) { latest, state, _ in
                        state = latest.translation
                    }
                    .onEnded { final in
                        offset.width += final.translation.width
                        offset.height += final.translation.height
                    }
            )
            .simultaneousGesture(
                MagnificationGesture()
                    .updating($gestureScale) { latest, state, _ in
                        state = latest
                    }
                    .onEnded { final in
                        scale *= final
                    }
            )
            .simultaneousGesture(
                RotationGesture()
                    .updating($gestureRotation) { latest, state, _ in
                        state = latest
                    }
                    .onEnded { final in
                        rotation += final
                    }
            )
    }
}

extension View {
    func transformable(scale: Binding<CGFloat>, offset: Binding<CGSize>, rotation: Binding<Angle>) -> some View {
        self.modifier(TransformModifier(scale: scale, offset: offset, rotation: rotation))
    }
}
