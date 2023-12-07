//
//  VariableBlurImageView.swift
//
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

import UIKit

open class VariableBlurImageView: UIImageView {
    
    private let variableBlurEngine = VariableBlurEngine()
    
    /// Adds a vertical variable blur to your image.
    /// This method works asynchronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UIKit coordinates.
    ///   - endPoint: The vertical end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func verticalVariableBlur(image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        transformAllVariations(ofImage: image, variationTransformMode: .sequential) { cgImage in
            try self.variableBlurEngine.applyVerticalVariableBlur(
                toImage:        cgImage,
                startPoint:     startPoint,
                endPoint:       endPoint,
                startRadius:    startRadius,
                endRadius:      endRadius
            )
        }
    }
    
    /// Adds a horizontal variable blur to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UIKit coordinates.
    ///   - endPoint: The horizontal end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func horizontalVariableBlur(image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        transformAllVariations(ofImage: image, variationTransformMode: .sequential) { cgImage in
            try self.variableBlurEngine.applyHorizontalVariableBlur(
                toImage:        cgImage,
                startPoint:     startPoint,
                endPoint:       endPoint,
                startRadius:    startRadius,
                endRadius:      endRadius
            )
        }
    }
    
    /// Adds a variable blur between two points to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UIKit coordinates.
    ///   - endPoint: The end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func variableBlur(image: UIImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        transformAllVariations(ofImage: image, variationTransformMode: .sequential) { cgImage in
            try self.variableBlurEngine.applyVariableBlur(
                toImage:        cgImage,
                startPoint:     startPoint,
                endPoint:       endPoint,
                startRadius:    startRadius,
                endRadius:      endRadius
            )
        }
    }
    
    private func transformAllVariations(ofImage image: UIImage, variationTransformMode: VariationTansformMode, applyingTransform block: @escaping (CGImage) throws -> CGImage) {
        self.image = image
        
        let currentStyle = traitCollection.userInterfaceStyle
        
        let imageVariations = self.getImageVariations(image: image, currentStyleFirst: variationTransformMode.currentStyleFirst)
        
        DispatchQueue.global().async {
            do {
                let imageSize = image.size
                
                let cgImagesOfVariations = imageVariations.compactMap { self.getCGImage(fromUIImage: $0) }
                
                guard cgImagesOfVariations.count == imageVariations.count else {
                    throw VariableBlurImageViewError.cannotExtractCGImageFromProvidedImage
                }
                
                let blurredImageVariations: [CGImage]
                switch variationTransformMode {
                case .tile(let tileMode):
                    let imageTiler = ImageTiler(tileMode: tileMode)
                    guard let tiledImage = imageTiler.tile(images: cgImagesOfVariations) else {
                        throw VariableBlurImageViewError.cannotTileImage
                    }
                    let blurredImage = try block(tiledImage)
                    blurredImageVariations = imageTiler.getComponentImages(image: blurredImage, desiredSize: imageSize)
                case .sequential:
                    var variations = [CGImage]()
                    for (i, cgImage) in cgImagesOfVariations.enumerated() {
                        let blurredImage = try block(cgImage)
                        // Set image when first result is ready
                        if i == 0 {
                            DispatchQueue.main.async {
                                self.image = UIImage(cgImage: blurredImage)
                            }
                        }
                        
                        variations.append(blurredImage)
                    }
                    blurredImageVariations = variations
                }
                
                let imageWithVariations = self.makeSingleImageWithStyleVariations(fromImages: blurredImageVariations, currentStyleFirst: variationTransformMode.currentStyleFirst, currentStyle: currentStyle)
                
                DispatchQueue.main.async {
                    self.image = imageWithVariations
                }
            } catch {
                #if DEBUG
                print("Could not apply variable blur to image: \(error)")
                #endif
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
    private func getImageVariations(image: UIImage, currentStyleFirst: Bool) -> [UIImage] {
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
        
        // Return the current user interface style first.
        let currentStyle = traitCollection.userInterfaceStyle
        
        if currentStyleFirst && currentStyle == .dark {
            return [darkImage, lightImage,]
        }
        
        return [lightImage, darkImage]
    }
    
    private func makeSingleImageWithStyleVariations(fromImages images: [CGImage], currentStyleFirst: Bool, currentStyle: UIUserInterfaceStyle) -> UIImage? {
        guard images.count >= 2 else {
            return nil
        }
        
        let darkFirst = currentStyleFirst && currentStyle == .dark
        
        let lightImage = darkFirst ? images[1] : images[0]
        let darkImage = darkFirst ? images[0] : images[1]
        
        let imageAsset = UIImageAsset()
        
        let lightMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .light)])
        imageAsset.register(UIImage(cgImage: lightImage), with: lightMode)
        
        let darkMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .dark)])
        imageAsset.register(UIImage(cgImage: darkImage), with: darkMode)
        
        return imageAsset.image(with: .current)
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
    
    enum VariationTansformMode {
        /// Tiles the image variations into one image and performs one transform
        case tile(tileMode: ImageTiler.ImageTileMode)
        
        /// Performs the transform on each image variation sequentially
        case sequential
        
        var currentStyleFirst: Bool {
            switch self {
            case .tile(_):
                return false
            case .sequential:
                return true
            }
        }
    }
    
}

extension VariableBlurImageView {
    enum VariableBlurImageViewError: String, Error {
        case cannotExtractCGImageFromProvidedImage
        case cannotTileImage
    }
}
