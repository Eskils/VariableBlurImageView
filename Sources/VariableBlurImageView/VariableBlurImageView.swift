//
//  VariableBlurImageView.swift
//
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

#if canImport(UIKit)
import UIKit

open class VariableBlurImageView: UIImageView {
    
    private let variableBlurEngine = VariableBlurEngine()
    
    /// Adds a vertical variable blur to your image.
    /// This method works asynchronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UI coordinates.
    ///   - endPoint: The vertical end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func verticalVariableBlur(image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        verticalVariableBlurImpl(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
    }
    
    /// Adds a horizontal variable blur to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UI coordinates.
    ///   - endPoint: The horizontal end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func horizontalVariableBlur(image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        horizontalVariableBlurImpl(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
    }
    
    /// Adds a variable blur between two points to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UI coordinates.
    ///   - endPoint: The end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func variableBlur(image: UIImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        variableBlurImpl(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
    }
    
}

#elseif canImport(AppKit)
import AppKit

extension CPImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
    }
}

open class VariableBlurImageView: NSImageView {
    
    private let variableBlurEngine = VariableBlurEngine()
    
    private var originalImage: NSImage?
    
    private var blurOperation: VariableBlurOperation?
    
    /// Adds a vertical variable blur to your image.
    /// This method works asynchronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UIKit coordinates.
    ///   - endPoint: The vertical end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func verticalVariableBlur(image: NSImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        originalImage = image
        blurOperation = .vertical(startPoint, endPoint, startRadius, endRadius)
        
        verticalVariableBlurImpl(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
    }
    
    /// Adds a horizontal variable blur to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UIKit coordinates.
    ///   - endPoint: The horizontal end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func horizontalVariableBlur(image: NSImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        originalImage = image
        blurOperation = .horizontal(startPoint, endPoint, startRadius, endRadius)
        
        horizontalVariableBlurImpl(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
    }
    
    /// Adds a variable blur between two points to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UIKit coordinates.
    ///   - endPoint: The end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func variableBlur(image: NSImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        originalImage = image
        blurOperation = .betweenTwoPoints(startPoint, endPoint, startRadius, endRadius)
        
        variableBlurImpl(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
    }
    
    open override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        
        guard let originalImage, let blurOperation else {
            return
        }
        
        blurOperation.performOperation(onImage: originalImage, imageView: self)
    }
    
}

#endif

extension VariableBlurImageView {
    
    func verticalVariableBlurImpl(image: CPImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
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
    
    func horizontalVariableBlurImpl(image: CPImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
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
    
    func variableBlurImpl(image: CPImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
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
    
    private func transformAllVariations(ofImage image: CPImage, variationTransformMode: VariationTansformMode, applyingTransform block: @escaping (CGImage) throws -> CGImage) {
        self.image = image
        
        #if canImport(UIKit)
        let currentStyle = traitCollection.userInterfaceStyle
        #endif
        
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
                                self.image = CPImage(cgImage: blurredImage)
                            }
                        }
                        
                        variations.append(blurredImage)
                    }
                    blurredImageVariations = variations
                }
                
                #if canImport(UIKit)
                let imageWithVariations = self.makeSingleImageWithStyleVariations(fromImages: blurredImageVariations, currentStyleFirst: variationTransformMode.currentStyleFirst, currentStyle: currentStyle)
                
                DispatchQueue.main.async {
                    self.image = imageWithVariations
                }
                #elseif canImport(AppKit)
                guard let firstImage = blurredImageVariations.first else {
                    return
                }
                DispatchQueue.main.async {
                    self.image = CPImage(cgImage: firstImage)
                }
                #endif
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

#if canImport(UIKit)
extension VariableBlurImageView {
    fileprivate func getImageVariations(image: UIImage, currentStyleFirst: Bool) -> [CPImage] {
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
    
    fileprivate func makeSingleImageWithStyleVariations(fromImages images: [CGImage], currentStyleFirst: Bool, currentStyle: UIUserInterfaceStyle) -> CPImage? {
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
    
    fileprivate func getCGImage(fromUIImage image: CPImage) -> CGImage? {
        if let cgImage = image.cgImage {
            return cgImage
        }
        
        if let ciImage = image.ciImage {
            CIContext().createCGImage(ciImage, from: ciImage.extent)
        }
        
        return nil
    }
}
#elseif canImport(AppKit)
extension VariableBlurImageView {
    fileprivate func getImageVariations(image: NSImage, currentStyleFirst: Bool) -> [CPImage] {
        return [image]
    }
    
    fileprivate func getCGImage(fromUIImage image: CPImage) -> CGImage? {
        return image.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
}
#endif

extension VariableBlurImageView {
    enum VariableBlurImageViewError: String, Error {
        case cannotExtractCGImageFromProvidedImage
        case cannotTileImage
    }
}
