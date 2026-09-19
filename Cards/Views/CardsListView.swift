//
//  CardsListView.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct CardsListView: View {
    @EnvironmentObject var store: CardStore
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @State private var selectedCard: Card?

    var thumbnailSize: CGSize {
        var scale: CGFloat = 1
        if verticalSizeClass == .regular, horizontalSizeClass == .regular {
            scale = 1.5
        }
        return Settings.thumbnailSize * scale
    }

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: thumbnailSize.width))]
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                list
                if store.cards.isEmpty {
                    initialView
                }
            }
            createButton
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .fullScreenCover(item: $selectedCard) { card in
            if let index = store.index(for: card) {
                SingleCardView(card: $store.cards[index])
                    .environmentObject(store)
            } else {
                Text("Card unavailable")
            }
        }
    }

    var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(store.cards) { card in
                    CardThumbnail(card: card)
                        .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                        .onTapGesture {
                            selectedCard = card
                        }
                        .contextMenu {
                            Button(action: {
                                store.remove(card)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }

    var initialView: some View {
        VStack(spacing: 12) {
            ZStack {
                CardThumbnail(card: Card(backgroundColor: Color(UIColor.systemBackground)))
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.accentColor)
            }
            .frame(width: thumbnailSize.width * 1.1, height: thumbnailSize.height * 1.1)
            .onTapGesture {
                selectedCard = store.addCard()
            }

            Text("Tap the plus button to add a card")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    var createButton: some View {
        Button(action: {
            selectedCard = store.addCard()
        }) {
            Label("Create New", systemImage: "plus")
                .frame(maxWidth: .infinity)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 14)
        .background(Color.black)
    }
}

struct CardsListView_Previews: PreviewProvider {
    static var previews: some View {
        CardsListView()
            .environmentObject(CardStore(defaultData: true))
    }
}
