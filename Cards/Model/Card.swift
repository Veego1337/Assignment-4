//
//  Card.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var backgroundColor: Color = .yellow
    var elements: [CardElement] = []

    mutating func addElement(uiImage: UIImage) {
        let imageFilename = uiImage.save()
        let element = ImageElement(
            imageFilename: imageFilename,
            uiImage: uiImage
        )
        elements.append(element)
        save()
    }

    mutating func addElement(text: TextElement) {
        elements.append(text)
        save()
    }

    mutating func remove(_ element: CardElement) {
        if let element = element as? ImageElement {
            UIImage.remove(name: element.imageFilename)
        }
        if let index = element.index(in: elements) {
            elements.remove(at: index)
        }
        save()
    }

    mutating func update(_ element: CardElement?, frameIndex: Int) {
        guard element is ImageElement,
              let index = element?.index(in: elements),
              var imageElement = elements[index] as? ImageElement
        else { return }

        imageElement.frameIndex = frameIndex
        elements[index] = imageElement
        save()
    }

    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let filename = "\(id).card"
            let url = URL.documentsDirectory.appendingPathComponent(filename)
            try data.write(to: url)
        } catch {
            print("Failed to save card:", error.localizedDescription)
        }
    }
}

extension Card: Codable {
    enum CodingKeys: CodingKey {
        case id, backgroundColorRGBA, imageElements, textElements
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: idString) ?? UUID()

        let rgba = try container.decode([CGFloat].self, forKey: .backgroundColorRGBA)
        if rgba.count == 4 {
            backgroundColor = Color(UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3]))
        } else {
            backgroundColor = .yellow
        }

        let images = try container.decodeIfPresent([ImageElement].self, forKey: .imageElements) ?? []
        let texts = try container.decodeIfPresent([TextElement].self, forKey: .textElements) ?? []
        elements = images + texts
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        try container.encode([r, g, b, a], forKey: .backgroundColorRGBA)

        let imageElements: [ImageElement] = elements.compactMap { $0 as? ImageElement }
        let textElements: [TextElement] = elements.compactMap { $0 as? TextElement }
        try container.encode(imageElements, forKey: .imageElements)
        try container.encode(textElements, forKey: .textElements)
    }
}
