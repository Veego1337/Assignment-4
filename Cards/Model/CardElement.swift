//
//  CardElement.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

protocol CardElement {
    var id: UUID { get }
    var transform: Transform { get set }
}

extension CardElement {
    func index(in array: [CardElement]) -> Int? {
        array.firstIndex { $0.id == id }
    }
}

struct ImageElement: CardElement {
    let id = UUID()
    var transform = Transform()
    var imageFilename: String?
    var frameIndex: Int?
    var uiImage: UIImage?

    var image: Image {
        Image(uiImage: uiImage ?? UIImage.error)
    }
}

extension ImageElement: Codable {
    enum CodingKeys: CodingKey {
        case transform, imageFilename, frameIndex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transform = try container.decode(Transform.self, forKey: .transform)
        frameIndex = try container.decodeIfPresent(Int.self, forKey: .frameIndex)
        imageFilename = try container.decodeIfPresent(String.self, forKey: .imageFilename)
        if let imageFilename = imageFilename {
            uiImage = UIImage.load(uuidString: imageFilename)
        } else {
            uiImage = UIImage.error
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transform, forKey: .transform)
        try container.encode(frameIndex, forKey: .frameIndex)
        try container.encode(imageFilename, forKey: .imageFilename)
    }
}

struct TextElement: CardElement {
    let id = UUID()
    var transform = Transform()
    var text: String = ""
    var textColor: Color = .black
    var textFont: String = "Gill Sans"
}

extension TextElement: Codable {
    enum CodingKeys: CodingKey {
        case transform, text, textColorRGBA, textFont
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transform = try container.decode(Transform.self, forKey: .transform)
        text = try container.decode(String.self, forKey: .text)
        textFont = try container.decode(String.self, forKey: .textFont)
        let rgba = try container.decode([CGFloat].self, forKey: .textColorRGBA)
        if rgba.count == 4 {
            textColor = Color(UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3]))
        } else {
            textColor = .black
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transform, forKey: .transform)
        try container.encode(text, forKey: .text)
        try container.encode(textFont, forKey: .textFont)

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(textColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        try container.encode([r, g, b, a], forKey: .textColorRGBA)
    }
}
