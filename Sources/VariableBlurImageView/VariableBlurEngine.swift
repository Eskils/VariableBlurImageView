//
//  VariableBlurEngine.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import Foundation
import CoreGraphics

public struct VariableBlurEngine {
    
    private let variableBlurMetal = VariableBlurMetal()
    
    public init() {}
    
    /// Adds a vertical variable blur to your image.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UI coordinates.
    ///   - endPoint: The vertical end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func applyVerticalVariableBlur(toImage image: CGImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) throws -> CGImage {
        return try variableBlurMetal.variableBlurVertical(
            image:          image,
            startPoint:     Float(startPoint),
            endPoint:       Float(endPoint),
            startRadius:    Float(startRadius),
            endRadius:      Float(endRadius)
        )
    }
    
    /// Adds a horizontal variable blur to your image.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UI coordinates.
    ///   - endPoint: The horizontal end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func applyHorizontalVariableBlur(toImage image: CGImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) throws -> CGImage {
        return try variableBlurMetal.variableBlurHorizontal(
            image:          image,
            startPoint:     Float(startPoint),
            endPoint:       Float(endPoint),
            startRadius:    Float(startRadius),
            endRadius:      Float(endRadius)
        )
    }
    
    /// Adds a variable blur between two points to your image.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UI coordinates.
    ///   - endPoint: The end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public func applyVariableBlur(toImage image: CGImage, startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) throws -> CGImage {
        return try variableBlurMetal.variableBlur(
            image:          image,
            startPoint:     SIMD2(x: Float(startPoint.x), y: Float(startPoint.y)),
            endPoint:       SIMD2(x: Float(endPoint.x), y: Float(endPoint.y)),
            startRadius:    Float(startRadius),
            endRadius:      Float(endRadius)
        )
    }
    
    /// Adds a variable blur following the lightness value in the provided gradient image.
    /// If the gradient image is smaller than the input image, the gradient image is tiled.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - gradient: The image describing the blur radius in terms of lightness. Preferrably a grayscale image.
    ///   - maxRadius: The max blur radius. Fully white corresponds to this radius, while black corresponds to 0.
    public func applyGradientVariableBlur(toImage image: CGImage, withGradient gradient: CGImage, maxRadius: CGFloat) throws -> CGImage {
        return try variableBlurMetal.gradientVariableBlur(
            image: image,
            gradientImage: gradient,
            maxRadius: Float(maxRadius)
        )
    }
    
    /// Adds multiple variable blurs as provided by an array of start/ent points and start/end radiuses.
    /// If the blurs overlap, the last blur will overrule.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - descriptions: An array of structures describing start/ent points and start/end radiuses.
    public func applyMultipleVariableBlurs(toImage image: CGImage, withDescriptions descriptions: [VariableBlurDescription]) throws -> CGImage {
        return try variableBlurMetal.multipleVariableBlur(
            image: image,
            descriptions: descriptions.map { $0.toMetalDescription() }
        )
    }
    
}
