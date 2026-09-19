//
//  TextModal.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct TextModal: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var textElement: TextElement

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter text", text: $textElement.text, onCommit: {
                    presentationMode.wrappedValue.dismiss()
                })
                .font(.title2)
                .padding(12)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 30)
            .navigationBarTitle("Add Text", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
