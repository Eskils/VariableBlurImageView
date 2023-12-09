//
//  GenerateImages.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import CoreGraphics
import VariableBlurImageView

struct GenerateImages {
    
    let variableBlurEngine = VariableBlurEngine()
    
    func imageTransforms(inputImage: CGImage, name: String, outputImages: inout [OutputImage]) {
        // Vertical blur
        OutputImage
            .from(image: inputImage, named: "\(name)-VerticalBlur-(0,20)-to-(50h,0)") { input in
                try variableBlurEngine.applyVerticalVariableBlur(
                    toImage: input,
                    startPoint: 0,
                    endPoint: CGFloat(input.height / 2),
                    startRadius: 20,
                    endRadius: 0
                )
            }?
            .adding(to: &outputImages)

        // Horizontal blur
        OutputImage
            .from(image: inputImage, named: "\(name)-HorizontalBlur-(0,20)-to-(50w,0)") { input in
                try variableBlurEngine.applyHorizontalVariableBlur(
                    toImage: input,
                    startPoint: 0,
                    endPoint: CGFloat(input.width / 2),
                    startRadius: 20,
                    endRadius: 0
                )
            }?
            .adding(to: &outputImages)

        // Variable blur
        OutputImage
            .from(image: inputImage, named: "\(name)-VariableBlur-((10w,15h),20)-to-((60w,40h),0)") { input in
                try variableBlurEngine.applyVariableBlur(
                    toImage: input,
                    startPoint: CGPoint(x: CGFloat(input.width) * 0.1, y: CGFloat(input.height) * 0.15),
                    endPoint: CGPoint(x: CGFloat(input.width) * 0.6, y: CGFloat(input.height) * 0.4),
                    startRadius: 20,
                    endRadius: 0
                )
            }?
            .adding(to: &outputImages)
        
        // Gradient blur
        OutputImage
            .from(image: inputImage, named: "\(name)-GradientBlur-20") { input in
                let gradientImage = try GenerateTestImages.image(atPath: inputURL.appendingPathComponent("TestAlpha.png").path)
                return try variableBlurEngine.applyGradientVariableBlur(
                    toImage: input,
                    withGradient: gradientImage,
                    maxRadius: 20
                )
            }?
            .adding(to: &outputImages)
        
        // MultipleBlurs
        OutputImage
            .from(image: inputImage, named: "\(name)-MultipleBlurs-20") { input in
                return try variableBlurEngine.applyMultipleVariableBlurs(
                    toImage: input,
                    withDescriptions: [
                        VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.4), startRadius: 20, endRadius: 0),
                        VariableBlurDescription(startPoint: CGPoint(x: 0, y: CGFloat(input.height)), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.5), startRadius: 20, endRadius: 0),
                    ]
                )
            }?
            .adding(to: &outputImages)
        
        // MultipleBlurs with overlap
        OutputImage
            .from(image: inputImage, named: "\(name)-MultipleBlurs-WithOverlap") { input in
                return try variableBlurEngine.applyMultipleVariableBlurs(
                    toImage: input,
                    withDescriptions: [
                        VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.6), startRadius: 20, endRadius: 0),
                        VariableBlurDescription(startPoint: CGPoint(x: 0, y: CGFloat(input.height)), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.4), startRadius: 20, endRadius: 0),
                    ]
                )
            }?
            .adding(to: &outputImages)
    }
    
}
