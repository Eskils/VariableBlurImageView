//
//  VariableBlurOperation.swift
//
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import Foundation
import CoreGraphics

enum VariableBlurOperation {
    /// Adds a vertical variable blur to your image.
    case vertical(CGFloat, CGFloat, CGFloat, CGFloat)
    
    /// Adds a horizontal variable blur to your image.
    case horizontal(CGFloat, CGFloat, CGFloat, CGFloat)
    
    /// Adds a variable blur between two points to your image.
    case betweenTwoPoints(CGPoint, CGPoint, CGFloat, CGFloat)
    
    /// Adds a variable blur following the lightness value in the provided gradient image.
    case gradient(CPImage, CGFloat)
    
    // Adds multiple variable blurs as provided by an array of start/ent points and start/end radiuses.
    case multiple([VariableBlurDescription])
    
    func performOperation(onImage image: CPImage, imageView: VariableBlurImageView) {
        switch self {
        case .vertical(let startPoint, let endPoint, let startRadius, let endRadius):
            imageView.verticalVariableBlur(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
        case .horizontal(let startPoint, let endPoint, let startRadius, let endRadius):
            imageView.horizontalVariableBlur(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
        case .betweenTwoPoints(let startPoint, let endPoint, let startRadius, let endRadius):
            imageView.variableBlur(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
        case .gradient(let gradientImage, let maxRadius):
            imageView.gradientBlur(image: image, gradientImage: gradientImage, maxRadius: maxRadius)
        case .multiple(let descriptions):
            imageView.multipleBlurs(image: image, descriptions: descriptions)
        }
    }
}
