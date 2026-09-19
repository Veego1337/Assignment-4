//
//  StickerModal.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import SwiftUI

struct StickerModal: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var stickerImage: UIImage?

    @State private var stickerNames: [String] = []

    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 15)
    ]

    static func loadStickers() -> [String] {
        var themes: [URL] = []
        var stickerPaths: [String] = []
        let fileManager = FileManager.default

        if let resourcePath = Bundle.main.resourcePath,
           let enumerator = fileManager.enumerator(
               at: URL(fileURLWithPath: resourcePath + "/Stickers"),
               includingPropertiesForKeys: nil,
               options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles]
           ) {
            for case let url as URL in enumerator where url.hasDirectoryPath {
                themes.append(url)
            }
        }

        for theme in themes {
            if let files = try? fileManager.contentsOfDirectory(atPath: theme.path) {
                for file in files where file.hasSuffix(".png") {
                    stickerPaths.append(theme.path + "/" + file)
                }
            }
        }
        return stickerPaths
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(stickerNames, id: \.self) { path in
                        if let image = UIImage(contentsOfFile: path) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .onTapGesture {
                                    stickerImage = image
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Stickers", displayMode: .inline)
            .onAppear {
                stickerNames = Self.loadStickers()
            }
        }
    }
}
