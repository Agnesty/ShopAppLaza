//
//  Extensions.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 27/07/23.
//

import UIKit
import SDWebImage

extension UIImage {
    // This method creates an image of a view
    convenience init?(view: UIView) {
        // Based on https://stackoverflow.com/a/41288197/1118398
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
        
        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
        } else {
            return nil
        }
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIImageView {
    func setImageWithPlugin(url: String) {
        let urlImage = URL(string: url)
        self.sd_setImage(with: urlImage)
    }
}

//extension CGSize {
//    func brandSizeForItemAt(sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let padding: CGFloat = 10
//        guard let item = viewModel.getBrandOnIndex(index: indexPath.item) else {
//            return CGSize(width: 50, height: 50)
//        }
//        let itemWidth = item.size(withAttributes: [
//            NSAttributedString.Key.font : FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 17)
//        ]).width
//        return CGSize(width: itemWidth + padding * 2, height: 50)
//    }
//}

