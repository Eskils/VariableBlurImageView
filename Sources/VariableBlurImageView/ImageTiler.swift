//
//  ImageTiler.swift
//
//
//  Created by Eskil Gjerde Sviggum on 07/12/2023.
//

import Foundation
import CoreGraphics

struct ImageTiler {
    
    private let tileMode: ImageTileMode
    
    init(tileMode: ImageTileMode) {
        self.tileMode = tileMode
    }
    
    func tile(images: [CGImage]) -> CGImage? {
        if images.isEmpty {
            return nil
        }
        
        if images.count == 1 {
            return images[0]
        }
        
        switch tileMode {
        case .vertical:
            return tileVertically(images: images)
        case .horizontal:
            return tileHorizontally(images: images)
        }
    }
    
    func getComponentImages(image: CGImage, desiredSize size: CGSize) -> [CGImage] {
        let numberOfImages = Int(CGFloat(tileMode.tilingDimensionSize(inImage: image)) / size[keyPath: tileMode.tilingDimensionCGSizeKeypath])
        
        var accumulatedOffset = CGPoint.zero
        
        return (0..<numberOfImages).compactMap { i in
            let croppedImage = image.cropping(to: CGRect(origin: accumulatedOffset, size: size))
            accumulatedOffset[keyPath: tileMode.tilingDimensionCGPointKeypath] += size[keyPath: tileMode.tilingDimensionCGSizeKeypath]
            return croppedImage
        }
    }
    
    private func tileHorizontally(images: [CGImage]) -> CGImage? {
        let width = images.reduce(0) { $0 + $1.width }
        let height = images.map { $0.height }.max() ?? 0
        
        guard let cgContext = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        
        var accumulatedWidth: CGFloat = 0
        for image in images {
            let width = CGFloat(image.width)
            let rect = CGRect(x: accumulatedWidth, y: 0, width: width, height: CGFloat(image.height))
            cgContext.draw(image, in: rect, byTiling: false)
            accumulatedWidth += width
        }
        
        return cgContext.makeImage()
    }
    
    private func tileVertically(images: [CGImage]) -> CGImage? {
        let width = images.map { $0.width }.max() ?? 0
        let height = images.reduce(0) { $0 + $1.height }
        
        guard let cgContext = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        
        var accumulatedHeight: CGFloat = 0
        for image in images.reversed() {
            let height = CGFloat(image.height)
            let rect = CGRect(x: 0, y: accumulatedHeight, width: CGFloat(image.width), height: height)
            cgContext.draw(image, in: rect, byTiling: false)
            accumulatedHeight += height
        }
        
        return cgContext.makeImage()
    }
}

extension ImageTiler {
    enum ImageTileMode {
        case vertical
        case horizontal
        
        fileprivate func tilingDimensionSize(inImage image: CGImage) -> Int {
            image[keyPath: tilingDimensionCGImageKeypath]
        }
        
        fileprivate var tilingDimensionCGSizeKeypath: WritableKeyPath<CGSize, CGFloat> {
            switch self {
            case .vertical:
                return \.height
            case .horizontal:
                return \.width
            }
        }
        
        fileprivate var tilingDimensionCGImageKeypath: KeyPath<CGImage, Int> {
            switch self {
            case .vertical:
                return \.height
            case .horizontal:
                return \.width
            }
        }
        
        fileprivate var tilingDimensionCGPointKeypath: WritableKeyPath<CGPoint, CGFloat> {
            switch self {
            case .vertical:
                return \.y
            case .horizontal:
                return \.x
            }
        }
    }
}
