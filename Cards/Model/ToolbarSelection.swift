//
//  ToolbarSelection.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import Foundation

enum ToolbarSelection: CaseIterable, Identifiable {
    case photoModal, frameModal, stickerModal, textModal

    var id: Int {
        hashValue
    }
}
