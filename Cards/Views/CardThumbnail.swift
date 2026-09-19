//
//  CardThumbnail.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct CardThumbnail: View {
    let card: Card

    var body: some View {
        card.backgroundColor
            .cornerRadius(10)
            .shadow(color: Color.cardShadow, radius: 3, x: 0.0, y: 0.0)
    }
}

struct CardThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        CardThumbnail(card: Card(backgroundColor: .blue))
            .frame(width: Settings.thumbnailSize.width, height: Settings.thumbnailSize.height)
    }
}
