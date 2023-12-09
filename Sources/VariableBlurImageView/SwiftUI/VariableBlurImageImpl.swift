//
//  VariableBlurImageImpl.swift
//
//
//  Created by Eskil Gjerde Sviggum on 09/12/2023.
//

import SwiftUI

#if canImport(UIKit)

struct VariableBlurImageImpl: UIViewRepresentable {
    
    private let image: UIImage
    private let blurOperation: VariableBlurOperation
    
    init(image: UIImage, blurOperation: VariableBlurOperation) {
        self.image = image
        self.blurOperation = blurOperation
    }
    
    func makeUIView(context: Context) -> VariableBlurImageView {
        let imageView = VariableBlurImageView()
        blurOperation.performOperation(onImage: image, imageView: imageView)
        return imageView
    }
    
    func updateUIView(_ uiView: VariableBlurImageView, context: Context) {
    }
}

#elseif canImport(AppKit)
struct VariableBlurImageImpl: NSViewRepresentable {
    
    private let image: NSImage
    private let blurOperation: VariableBlurOperation
    
    init(image: NSImage, blurOperation: VariableBlurOperation) {
        self.image = image
        self.blurOperation = blurOperation
    }
    
    func makeNSView(context: Context) -> VariableBlurImageView {
        let imageView = VariableBlurImageView()
        blurOperation.performOperation(onImage: image, imageView: imageView)
        return imageView
    }
    
    func updateNSView(_ uiView: VariableBlurImageView, context: Context) {
    }
}
#endif
