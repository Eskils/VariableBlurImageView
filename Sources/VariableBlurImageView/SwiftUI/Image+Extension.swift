//
//  Image+Extension.swift
//
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import SwiftUI

@available(iOS 16.0, macCatalyst 16.0, tvOS 16.0, macOS 13.0, *)
extension Image {
    
    /// Adds a vertical variable blur to your image.
    /// This method works asynchronously.
    /// Image variations are not supported.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The vertical start point. In UIKit coordinates.
    ///   - endPoint: The vertical end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    @MainActor
    @ViewBuilder
    public func verticalVariableBlur(startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) -> some View {
        let imageRendrer = ImageRenderer(content: self)
        
        if let cpImage = imageRendrer.cpImage {
            VerticalVariableBlurImage(
                image: cpImage,
                startPoint: startPoint,
                endPoint: endPoint,
                startRadius: startRadius,
                endRadius: endRadius
            )
        } else {
            self
        }
    }
    
    /// Adds a horizontal variable blur to your image.
    /// This method works asynchronously.
    /// Image variations are not supported.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The horizontal start point. In UIKit coordinates.
    ///   - endPoint: The horizontal end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    @MainActor
    @ViewBuilder
    public func horizontalVariableBlur(startPoint: CGFloat, endPoint: CGFloat, startRadius: CGFloat, endRadius: CGFloat) -> some View {
        let imageRendrer = ImageRenderer(content: self)
        
        if let cpImage = imageRendrer.cpImage {
            HorizontalVariableBlurImage(
                image: cpImage,
                startPoint: startPoint,
                endPoint: endPoint,
                startRadius: startRadius,
                endRadius: endRadius
            )
        } else {
            self
        }
    }
    
    /// Adds a variable blur to your image.
    /// This method works asynchronously.
    /// Image variations are not supported.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - startPoint: The start point. In UIKit coordinates.
    ///   - endPoint: The end point. In UIKit coordinates.
    ///   - startRadius: The blur radius at the start point.
    ///   - endRadius: The blur radius ar the end point.
    @MainActor
    @ViewBuilder
    public func variableBlur(startPoint: CGPoint, endPoint: CGPoint, startRadius: CGFloat, endRadius: CGFloat) -> some View {
        let imageRendrer = ImageRenderer(content: self)
        
        if let cpImage = imageRendrer.cpImage {
            VariableBlurImage(
                image: cpImage,
                startPoint: startPoint,
                endPoint: endPoint,
                startRadius: startRadius,
                endRadius: endRadius
            )
        } else {
            self
        }
    }
    
    /// Adds a variable blur following the lightness value in the provided gradient image.
    /// If the gradient image is smaller than the input image, the gradient image is tiled.
    /// This method works asyncronously.
    /// Image variations are not supported.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - gradient: The image describing the blur radius in terms of lightness. Preferrably a grayscale image.
    ///   - maxRadius: The max blur radius. Fully white corresponds to this radius, while black corresponds to 0.
    @MainActor
    @ViewBuilder
    public func gradientBlur(gradientImage: Image, maxRadius: CGFloat) -> some View {
        let imageRendrer = ImageRenderer(content: self)
        let gradientImageRendrer = ImageRenderer(content: gradientImage)
        
        if let cpImage = imageRendrer.cpImage,
           let cpGradientImage = gradientImageRendrer.cpImage {
            GradientBlurImage(
                image: cpImage,
                gradientImage: cpGradientImage,
                maxRadius: maxRadius
            )
        } else {
            self
        }
    }
    
    /// Adds multiple variable blurs as provided by an array of start/ent points and start/end radiuses.
    /// If the blurs overlap, the last blur will overrule.
    /// This method works asyncronously.
    /// Image variations are not supported.
    /// - Parameters:
    ///   - image: The image to blur.
    ///   - descriptions: An array of structures describing start/ent points and start/end radiuses.
    @MainActor
    @ViewBuilder
    public func mutlipleBlurs(descriptions: [VariableBlurDescription]) -> some View {
        let imageRendrer = ImageRenderer(content: self)
        
        if let cpImage = imageRendrer.cpImage {
            MultipleBlursImage(
                image: cpImage,
                descriptions: descriptions
            )
        } else {
            self
        }
    }
    
}

@available(iOS 16.0, macCatalyst 16.0, tvOS 16.0, macOS 13.0, *)
extension ImageRenderer {
    
    @MainActor
    var cpImage: CPImage? {
        #if canImport(UIKit)
        return self.uiImage
        #elseif canImport(AppKit)
        return self.nsImage
        #endif
    }
    
}

