//
//  CardStore.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

class CardStore: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedElement: CardElement?

    init(defaultData: Bool = false) {
        cards = defaultData ? Self.initialCards : load()
    }

    func index(for card: Card) -> Int? {
        cards.firstIndex { $0.id == card.id }
    }

    func addCard() -> Card {
        let card = Card(backgroundColor: Color.random())
        cards.append(card)
        card.save()
        return card
    }

    func remove(_ card: Card) {
        for element in card.elements {
            if let imageElement = element as? ImageElement {
                UIImage.remove(name: imageElement.imageFilename)
            }
        }
        let url = URL.documentsDirectory.appendingPathComponent("\(card.id).card")
        try? FileManager.default.removeItem(at: url)

        if let index = index(for: card) {
            cards.remove(at: index)
        }
    }

    func load() -> [Card] {
        var loadedCards: [Card] = []
        let path = URL.documentsDirectory.path
        guard let enumerator = FileManager.default.enumerator(atPath: path),
              let files = enumerator.allObjects as? [String]
        else { return loadedCards }

        let cardFiles = files.filter { $0.hasSuffix(".card") }
        for cardFile in cardFiles {
            do {
                let filePath = path + "/" + cardFile
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                let card = try JSONDecoder().decode(Card.self, from: data)
                loadedCards.append(card)
            } catch {
                print("Error loading \(cardFile):", error.localizedDescription)
            }
        }
        return loadedCards
    }

    static var initialCards: [Card] = [
        Card(backgroundColor: .green),
        Card(backgroundColor: .orange),
        Card(backgroundColor: .red),
        Card(backgroundColor: .purple),
        Card(backgroundColor: .yellow)
    ]
}
