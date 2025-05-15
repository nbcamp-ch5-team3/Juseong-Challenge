//
//  UIImage+Extension.swift
//  iTunesApp
//
//  Created by 박주성 on 5/14/25.
//

import UIKit

extension UIImage {    
    func averageColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }

        let context = CIContext()
        let inputImage = CIImage(cgImage: cgImage)
        let extent = inputImage.extent
        let parameters = [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: extent)]
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: parameters),
              let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: CGColorSpaceCreateDeviceRGB())

        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: 1)
    }
}
