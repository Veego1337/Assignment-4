//
//  CardToolbar.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct CardToolbar: ViewModifier {
    @EnvironmentObject var store: CardStore

    @Binding var currentModal: ToolbarSelection?
    @Binding var card: Card
    
    // Closure passed from the parent view to handle dismissal safely
    var dismissAction: () -> Void

    @State private var frameIndex: Int?
    @State private var stickerImage: UIImage?
    @State private var textElement = TextElement()

    var menu: some View {
        Menu {
            Button(action: {
                if UIPasteboard.general.hasImages, let images = UIPasteboard.general.images {
                    for image in images {
                        card.addElement(uiImage: image)
                    }
                } else if UIPasteboard.general.hasStrings, let strings = UIPasteboard.general.strings {
                    for str in strings {
                        card.addElement(text: TextElement(text: str))
                    }
                }
            }) {
                Label("Paste", systemImage: "doc.on.clipboard")
            }
            .disabled(!UIPasteboard.general.hasImages && !UIPasteboard.general.hasStrings)
        } label: {
            Label("Add", systemImage: "ellipsis.circle")
        }
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    menu
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismissAction() // Trigger the dismissal closure
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    BottomToolbar(
                        card: $card,
                        modal: $currentModal
                    )
                }
            }
            .sheet(item: $currentModal) { item in
                switch item {
                case .photoModal:
                    PhotosModal(card: $card)
                case .frameModal:
                    FrameModal(frameIndex: $frameIndex)
                        .onDisappear {
                            if let frameIndex = frameIndex {
                                card.update(store.selectedElement, frameIndex: frameIndex)
                            }
                            frameIndex = nil
                        }
                case .stickerModal:
                    StickerModal(stickerImage: $stickerImage)
                        .onDisappear {
                            if let img = stickerImage {
                                card.addElement(uiImage: img)
                            }
                            stickerImage = nil
                        }
                case .textModal:
                    TextModal(textElement: $textElement)
                        .onDisappear {
                            if !textElement.text.isEmpty {
                                card.addElement(text: textElement)
                            }
                            textElement = TextElement()
                        }
                }
            }
    }
}
