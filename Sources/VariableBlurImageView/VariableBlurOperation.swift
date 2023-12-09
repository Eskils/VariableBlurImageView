//
//  VariableBlurOperation.swift
//
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import Foundation

enum VariableBlurOperation {
    /// Adds a vertical variable blur to your image.
    case vertical(CGFloat, CGFloat, CGFloat, CGFloat)
    
    /// Adds a horizontal variable blur to your image.
    case horizontal(CGFloat, CGFloat, CGFloat, CGFloat)
    
    /// Adds a variable blur between two points to your image.
    case betweenTwoPoints(CGPoint, CGPoint, CGFloat, CGFloat)
    
    func performOperation(onImage image: CPImage, imageView: VariableBlurImageView) {
        switch self {
        case .vertical(let startPoint, let endPoint, let startRadius, let endRadius):
            imageView.verticalVariableBlur(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
        case .horizontal(let startPoint, let endPoint, let startRadius, let endRadius):
            imageView.horizontalVariableBlur(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
        case .betweenTwoPoints(let startPoint, let endPoint, let startRadius, let endRadius):
            imageView.variableBlur(image: image, startPoint: startPoint, endPoint: endPoint, startRadius: startRadius, endRadius: endRadius)
        }
    }
}
