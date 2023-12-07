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
    /// This method works asynchronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UIKit coordinates.
    ///   - endPoint: The vertical end point. In UIKit coordinates.
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
    /// This method works asyncronously.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UIKit coordinates.
    ///   - endPoint: The horizontal end point. In UIKit coordinates.
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
    ///   - startPoint: The start point. In UIKit coordinates.
    ///   - endPoint: The end point. In UIKit coordinates.
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
    
}
