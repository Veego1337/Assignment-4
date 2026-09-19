//
//  BottomToolbar.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct ToolbarButton: View {
    let modal: ToolbarSelection

    private let modalButton: [ToolbarSelection: (text: String, imageName: String)] = [
        .photoModal: ("Photos", "photo"),
        .frameModal: ("Frames", "square.on.circle"),
        .stickerModal: ("Stickers", "heart.circle"),
        .textModal: ("Text", "textformat")
    ]

    var body: some View {
        if let item = modalButton[modal] {
            VStack(spacing: 4) {
                Image(systemName: item.imageName)
                    .font(.system(size: 24))
                Text(item.text)
                    .font(.caption)
            }
            .padding(.top, 4)
            .foregroundColor(.primary)
        }
    }
}

struct BottomToolbar: View {
    @EnvironmentObject var store: CardStore
    @Binding var card: Card
    @Binding var modal: ToolbarSelection?

    func defaultButton(_ selection: ToolbarSelection) -> some View {
        Button(action: {
            modal = selection
        }) {
            ToolbarButton(modal: selection)
        }
    }

    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(ToolbarSelection.allCases) { selection in
                Spacer()
                switch selection {
                case .frameModal:
                    defaultButton(selection)
                        .disabled(
                            store.selectedElement == nil ||
                            !(store.selectedElement is ImageElement)
                        )
                default:
                    defaultButton(selection)
                }
                Spacer()
            }
        }
    }
}
