//
//  VariableBlurImage.swift
//
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import SwiftUI

/// An image view which adds a vertical variable blur.
public struct VerticalVariableBlurImage: View {
    private let image: CPImage
    private let blurOperation: VariableBlurOperation
    
    
    #if canImport(UIKit)
    /// Adds a vertical variable blur to your image.
    /// This method words asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UI coordinates.
    ///   - endPoint: The vertical end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end
    public init(image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        self.blurOperation = .vertical(startPoint, endPoint, startRadius, endRadius)
    }
    #elseif canImport(AppKit)
    /// Adds a vertical variable blur to your image.
    /// This method words asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UI coordinates.
    ///   - endPoint: The vertical end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end
    public init(image: NSImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        self.blurOperation = .vertical(startPoint, endPoint, startRadius, endRadius)
    }
    #endif
    
    public var body: some View {
        VariableBlurImageImpl(image: image, blurOperation: blurOperation)
    }
}

/// An image view which adds a horizontal variable blur.
public struct HorizontalVariableBlurImage: View {
    private let image: CPImage
    private let blurOperation: VariableBlurOperation
    
    #if canImport(UIKit)
    /// Adds a horizontal variable blur to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UI coordinates.
    ///   - endPoint: The horizontal end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public init(image: UIImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        self.blurOperation = .horizontal(startPoint, endPoint, startRadius, endRadius)
    }
    #elseif canImport(AppKit)
    /// Adds a horizontal variable blur to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UI coordinates.
    ///   - endPoint: The horizontal end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public init(image: NSImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        self.blurOperation = .horizontal(startPoint, endPoint, startRadius, endRadius)
    }
    #endif
    
    
    public var body: some View {
        VariableBlurImageImpl(image: image, blurOperation: blurOperation)
    }
}

/// An image view which adds a variable blur between two points.
public struct VariableBlurImage: View {
    private let image: CPImage
    private let blurOperation: VariableBlurOperation
    
    #if canImport(UIKit)
    /// Adds a variable blur between two points to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UI coordinates.
    ///   - endPoint: The end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public init(image: UIImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        self.blurOperation = .betweenTwoPoints(startPoint, endPoint, startRadius, endRadius)
    }
    #elseif canImport(AppKit)
    /// Adds a variable blur between two points to your image.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UI coordinates.
    ///   - endPoint: The end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public init(image: NSImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.image = image
        self.blurOperation = .betweenTwoPoints(startPoint, endPoint, startRadius, endRadius)
    }
    #endif
    
    public var body: some View {
        VariableBlurImageImpl(image: image, blurOperation: blurOperation)
    }
}

/// An image view which adds a variable blur following the lightness value in the provided gradient image.
public struct GradientBlurImage: View {
    private let image: CPImage
    private let blurOperation: VariableBlurOperation
    
    #if canImport(UIKit)
    /// Adds a variable blur following the lightness value in the provided gradient image.
    /// If the gradient image is smaller than the input image, the gradient image is tiled.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - gradient: The image describing the blur radius in terms of lightness. Preferrably a grayscale image.
    ///   - maxRadius: The max blur radius. Fully white corresponds to this radius, while black corresponds to 0.
    public init(image: UIImage, gradientImage: UIImage, maxRadius: CGFloat) {
        self.image = image
        self.blurOperation = .gradient(gradientImage, maxRadius)
    }
    #elseif canImport(AppKit)
    /// Adds a variable blur following the lightness value in the provided gradient image.
    /// If the gradient image is smaller than the input image, the gradient image is tiled.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - gradient: The image describing the blur radius in terms of lightness. Preferrably a grayscale image.
    ///   - maxRadius: The max blur radius. Fully white corresponds to this radius, while black corresponds to 0.
    public init(image: NSImage, gradientImage: NSImage, maxRadius: CGFloat) {
        self.image = image
        self.blurOperation = .gradient(gradientImage, maxRadius)
    }
    #endif
    
    public var body: some View {
        VariableBlurImageImpl(image: image, blurOperation: blurOperation)
    }
}

/// An image view which adds multiple variable blurs to the image.
public struct MultipleBlursImage: View {
    private let image: CPImage
    private let blurOperation: VariableBlurOperation
    
    #if canImport(UIKit)
    /// Adds multiple variable blurs as provided by an array of start/ent points and start/end radiuses.
    /// If the blurs overlap, the last blur will overrule.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - descriptions: An array of structures describing start/ent points and start/end radiuses.
    public init(image: UIImage, descriptions: [VariableBlurDescription]) {
        self.image = image
        self.blurOperation = .multiple(descriptions)
    }
    #elseif canImport(AppKit)
    /// Adds multiple variable blurs as provided by an array of start/ent points and start/end radiuses.
    /// If the blurs overlap, the last blur will overrule.
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - descriptions: An array of structures describing start/ent points and start/end radiuses.
    public init(image: NSImage, descriptions: [VariableBlurDescription]) {
        self.image = image
        self.blurOperation = .multiple(descriptions)
    }
    #endif
    
    public var body: some View {
        VariableBlurImageImpl(image: image, blurOperation: blurOperation)
    }
}
