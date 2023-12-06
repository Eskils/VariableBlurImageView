//
//  VariableBlur.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import Foundation
import CoreGraphics

public struct VariableBlur {
    
    private let variableBlurMetal = VariableBlurMetal()
    
    public init() {}
    
    public func applyVerticalVariableBlur(toImage image: CGImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) throws -> CGImage {
        return try variableBlurMetal.variableBlurVertical(
            image:          image,
            startPoint:     Float(startPoint),
            endPoint:       Float(endPoint),
            startRadius:    Float(startRadius),
            endRadius:      Float(endRadius)
        )
    }
    
    public func applyHorizontalVariableBlur(toImage image: CGImage, startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) throws -> CGImage {
        return try variableBlurMetal.variableBlurHorizontal(
            image:          image,
            startPoint:     Float(startPoint),
            endPoint:       Float(endPoint),
            startRadius:    Float(startRadius),
            endRadius:      Float(endRadius)
        )
    }
    
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
