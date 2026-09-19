//
//  FrameModal.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct FrameModal: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var frameIndex: Int?

    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 15)
    ]

    private let style = StrokeStyle(lineWidth: 4, lineJoin: .round)

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<Shapes.shapes.count, id: \.self) { index in
                        Shapes.shapes[index]
                            .stroke(Color.primary, style: style)
                            .background(
                                Shapes.shapes[index]
                                    .fill(Color.secondary.opacity(0.2))
                            )
                            .frame(width: 80, height: 80)
                            .padding(8)
                            .onTapGesture {
                                frameIndex = index
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Frames", displayMode: .inline)
        }
    }
}
