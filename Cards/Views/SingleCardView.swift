//
//  SingleCardView.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct SingleCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var store: CardStore

    @Binding var card: Card
    @State private var currentModal: ToolbarSelection?

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                CardDetailView(
                    card: $card,
                    viewScale: Settings.calculateScale(proxy.size)
                )
                .frame(
                    width: Settings.calculateSize(proxy.size).width,
                    height: Settings.calculateSize(proxy.size).height
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .modifier(CardToolbar(
                    currentModal: $currentModal,
                    card: $card,
                    dismissAction: {
                        presentationMode.wrappedValue.dismiss()
                    }
                ))
            }
            .background(Color.background.edgesIgnoringSafeArea(.all))
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                card.save()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    card.save()
                }
            }
        }
        // Forces a standard stack instead of split-view on larger devices
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
