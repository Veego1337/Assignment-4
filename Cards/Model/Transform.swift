//
//  Transform.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct Transform: Codable {
    var size: CGSize = CGSize(
        width: Settings.defaultElementSize.width,
        height: Settings.defaultElementSize.height
    )
    var rotation: Angle = .zero
    var offset: CGSize = .zero
}
