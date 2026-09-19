//
//  Settings.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

enum Settings {
    static let cardSize = CGSize(width: 1300, height: 2000)
    static let thumbnailSize = CGSize(width: 150, height: 250)
    static let defaultElementSize = CGSize(width: 800, height: 800)
    static let borderColor: Color = .blue
    static let borderWidth: CGFloat = 5

    static func calculateSize(_ size: CGSize) -> CGSize {
        var newSize = size
        let ratio = cardSize.width / cardSize.height
        if size.width < size.height {
            newSize.height = min(size.height, newSize.width / ratio)
            newSize.width = min(size.width, newSize.height * ratio)
        } else {
            newSize.width = min(size.width, newSize.height * ratio)
            newSize.height = min(size.height, newSize.width / ratio)
        }
        return newSize
    }

    static func calculateScale(_ size: CGSize) -> CGFloat {
        let newSize = calculateSize(size)
        return newSize.width / cardSize.width
    }

    static func calculateDropOffset(proxy: GeometryProxy, location: CGPoint) -> CGSize {
        let center = CGPoint(x: proxy.size.width / 2.0, y: proxy.size.height / 2.0)
        let scale = calculateScale(proxy.size)
        return CGSize(
            width: (location.x - center.x) / scale,
            height: (location.y - center.y) / scale
        )
    }
}
