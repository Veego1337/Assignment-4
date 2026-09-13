import SwiftUI

struct PhotoElement: Identifiable {
    let id = UUID()
    var image: String
    var isSystemImage: Bool = false
    var scale: CGFloat = 1.0
    var offset: CGSize = .zero
    var rotation: Angle = .zero
    var color: Color = .primary
}
