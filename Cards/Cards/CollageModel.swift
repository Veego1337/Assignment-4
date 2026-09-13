import SwiftUI

class CollageModel: ObservableObject {
    @Published var elements: [PhotoElement] = []
    @Published var backgroundColor: Color = .white
    
    func addSticker() {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple]
        let newElement = PhotoElement(
            image: "star.fill",
            isSystemImage: true,
            color: colors.randomElement() ?? .yellow
        )
        elements.append(newElement)
    }
    
    func addElephantPhoto() {
        let newElement = PhotoElement(image: "image_1987a0")
        elements.append(newElement)
    }
    
    func clearCollage() {
        elements.removeAll()
        backgroundColor = .white
    }
}
