//
//  UIImageExtensions.swift
//  Cards
//
//  Created by Luca on 9/19/26.
//

import UIKit

extension URL {
    // iOS 14 backport for URL.documentsDirectory
    static var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension UIImage {
    static var error: UIImage {
        UIImage(systemName: "exclamationmark.triangle") ?? UIImage()
    }

    func save() -> String {
        let filename = UUID().uuidString + ".png"
        let url = URL.documentsDirectory.appendingPathComponent(filename)
        let resized = self.resize(to: CGSize(width: 800, height: 800))
        if let data = resized.pngData() {
            try? data.write(to: url)
        }
        return filename
    }

    static func load(uuidString: String) -> UIImage {
        let url = URL.documentsDirectory.appendingPathComponent(uuidString)
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return UIImage.error
    }

    static func remove(name: String?) {
        guard let name = name else { return }
        let url = URL.documentsDirectory.appendingPathComponent(name)
        try? FileManager.default.removeItem(at: url)
    }

    func resize(to targetSize: CGSize) -> UIImage {
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let factor = min(widthRatio, heightRatio)
        if factor >= 1.0 { return self }

        let newSize = CGSize(width: size.width * factor, height: size.height * factor)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
