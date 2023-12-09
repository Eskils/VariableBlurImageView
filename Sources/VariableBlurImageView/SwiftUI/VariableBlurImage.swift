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

#if canImport(UIKit)

private struct VariableBlurImageImpl: UIViewRepresentable {
    
    private let image: UIImage
    private let blurOperation: VariableBlurOperation
    
    init(image: UIImage, blurOperation: VariableBlurOperation) {
        self.image = image
        self.blurOperation = blurOperation
    }
    
    public func makeUIView(context: Context) -> VariableBlurImageView {
        let imageView = VariableBlurImageView()
        blurOperation.performOperation(onImage: image, imageView: imageView)
        return imageView
    }
    
    public func updateUIView(_ uiView: VariableBlurImageView, context: Context) {
    }
}

#elseif canImport(AppKit)
private struct VariableBlurImageImpl: NSViewRepresentable {
    
    private let image: NSImage
    private let blurOperation: VariableBlurOperation
    
    init(image: NSImage, blurOperation: VariableBlurOperation) {
        self.image = image
        self.blurOperation = blurOperation
    }
    
    public func makeNSView(context: Context) -> VariableBlurImageView {
        let imageView = VariableBlurImageView()
        blurOperation.performOperation(onImage: image, imageView: imageView)
        return imageView
    }
    
    public func updateNSView(_ uiView: VariableBlurImageView, context: Context) {
    }
}
#endif
