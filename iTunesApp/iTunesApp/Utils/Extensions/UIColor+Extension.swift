//
//  UIColor+Extension.swift
//  iTunesApp
//
//  Created by 박주성 on 5/14/25.
//

import UIKit

extension UIColor {
    var isDarkColor: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        // 밝기 공식
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        return luminance < 0.5
    }
}
