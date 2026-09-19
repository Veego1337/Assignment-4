//
//  CardsApp.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

@main
struct CardsApp: App {
    @StateObject var store = CardStore(defaultData: false)

    var body: some Scene {
        WindowGroup {
            CardsListView()
                .environmentObject(store)
        }
    }
}
