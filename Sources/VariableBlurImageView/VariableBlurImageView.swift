//
//  VariableBlurImageView.swift
//  Dippel
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

import UIKit

class VariableBlurImageView: UIImageView {
    
    private let variableBlurMetal = VariableBlurMetal()
    
    func setImage(_ image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        DispatchQueue.global().async {
            do {
                let imageSize = image.size
                let imageVariations = self.getImageVariations(image: image)
                let horizontalVariations = self.composeDoubleImageHorizontally(images: imageVariations)
                
                let blurredImage = try self.applyVariableBlur(
                    toImage:        horizontalVariations,
                    startPoint:     startPoint,
                    endPoint:       endPoint,
                    startRadius:    startRadius,
                    endRadius:      endRadius
                )
                
                let imageWithVariations = self.doubleImageToUserInterfaceStyleVariations(cgImage: blurredImage, size: imageSize) ?? UIImage(cgImage: blurredImage)
                
                DispatchQueue.main.async {
                    self.image = imageWithVariations
                }
            } catch {
                Logger.log("Could not apply variable blur to image: \(error)")
                self.image = image
            }
        }
    }
    
    private func getImageVariations(image: UIImage) -> [UIImage] {
        guard let imageAsset = image.imageAsset else {
            return [image]
        }
        
        let lightTrait = UITraitCollection(userInterfaceStyle: .light)
        let lightImage = imageAsset.image(with: lightTrait)
        
        let darkTrait = UITraitCollection(userInterfaceStyle: .dark)
        let darkImage = imageAsset.image(with: darkTrait)
        
        if lightImage == darkImage {
            return [image]
        }
        
        return [lightImage, darkImage]
    }
    
    private func composeDoubleImageHorizontally(images: [UIImage]) -> UIImage {
        if images.isEmpty {
            return UIImage()
        }
        
        if images.count == 1 {
            return images.first!
        }
        
        let singleImageSize = images.first!.size
        
        let cgContext = CGContext(data: nil, width: images.count * Int(singleImageSize.width), height: Int(singleImageSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let cgContext else {
            return images.first!
        }
        
        for (i, image) in images.enumerated() {
            if let cgImage = image.cgImage {
                let rect = CGRect(x: CGFloat(i) * singleImageSize.width, y: 0, width: singleImageSize.width, height: singleImageSize.height)
                cgContext.draw(cgImage, in: rect, byTiling: false)
            }
        }
        
        guard let image = cgContext.makeImage() else {
            return images.first!
        }
        
        return UIImage(cgImage: image)
    }
    
    func doubleImageToUserInterfaceStyleVariations(cgImage: CGImage, size: CGSize) -> UIImage? {
        let context = CIContext()
        let ciImage = CIImage(cgImage: cgImage)
        
        guard
            let lightImage = context.createCGImage(ciImage, from: CGRect(origin: .zero, size: size)),
            let darkImage = context.createCGImage(ciImage, from: CGRect(origin: CGPoint(x: size.width, y: 0), size: size))
        else {
            return nil
        }
        
        let imageAsset = UIImageAsset()
        
        let lightMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .light)])
        imageAsset.register(UIImage(cgImage: lightImage), with: lightMode)
        
        let darkMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .dark)])
        imageAsset.register(UIImage(cgImage: darkImage), with: darkMode)
        
        return imageAsset.image(with: .current)
    }
    
    private func applyVariableBlur(toImage image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) throws -> CGImage {
        guard let cgImage = getCGImage(fromUIImage: image) else {
            throw VariableBlurImageViewError.cannotExtractCGImageFromProvidedImage
        }
        
        return try variableBlurMetal.variableBlurVertical(
            image:          cgImage,
            startPoint:     Float(startPoint),
            endPoint:       Float(endPoint),
            startRadius:    Float(startRadius),
            endRadius:      Float(endRadius)
        )
    }
    
    private func getCGImage(fromUIImage image: UIImage) -> CGImage? {
        if let cgImage = image.cgImage {
            return cgImage
        }
        
        if let ciImage = image.ciImage {
            CIContext().createCGImage(ciImage, from: ciImage.extent)
        }
        
        return nil
    }
    
}

extension VariableBlurImageView {
    enum VariableBlurImageViewError: String, Error {
        case cannotExtractCGImageFromProvidedImage
    }
}
