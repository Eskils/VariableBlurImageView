//
//  VariableBlurDescription.swift
//
//
//  Created by Eskil Gjerde Sviggum on 09/12/2023.
//

import Foundation
import CoreGraphics
import simd

/// Describe a variable blur’s points and radiuses.
public struct VariableBlurDescription {
    /// The start point of the blur. In UI coordinates.
    public let startPoint: CGPoint
    
    /// The end point of the blur. In UI coordinates.
    public let endPoint: CGPoint
    
    /// The blur radius at the start point.
    public let startRadius: CGFloat
    
    /// The blur radius ar the end point.
    public let endRadius: CGFloat
    
    /// Makes a description describing a variable blur
    /// You may use this with the `.multipleBlurs` method.
    /// - Parameters:
    ///   - startPoint: The start point. In UI coordinates.
    ///   - endPoint: The end point. In UI coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    public init(startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.startRadius = startRadius
        self.endRadius = endRadius
    }
}

struct VariableBlurDescriptionMetal {
    let startPoint: SIMD2<Float>
    let endPoint: SIMD2<Float>
    let startRadius: Float
    let endRadius: Float
}


extension VariableBlurDescription {
    
    func toMetalDescription() -> VariableBlurDescriptionMetal {
        VariableBlurDescriptionMetal(
            startPoint: SIMD2<Float>(x: Float(self.startPoint.x), y: Float(self.startPoint.y)),
            endPoint: SIMD2<Float>(x: Float(self.endPoint.x), y: Float(self.endPoint.y)),
            startRadius: Float(startRadius),
            endRadius: Float(endRadius)
        )
    }
    
}
