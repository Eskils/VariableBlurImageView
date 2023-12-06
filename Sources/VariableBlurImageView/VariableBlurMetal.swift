//
//  VariableBlurMetal.swift
//  Dippel
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

import CoreGraphics
import Metal

class VariableBlurMetal {
    
    private static let variableBlurVerticalFunctionName = "variableBlurVertical"
    private lazy var device = MTLCreateSystemDefaultDevice()
    private lazy var variableBlurVerticalFunction: MetalFunction? = {
        device.flatMap {
            do {
                return try MetalFunction.precompileMetalFunction(withName: Self.variableBlurVerticalFunctionName, device: $0)
            } catch {
                #if DEBUG
                print("Cannot precompile ordered dithering function with error: \(error)")
                #endif
                return nil
            }
        }
    }()
    
    func variableBlurVertical(image: CGImage, startPoint: Float, endPoint: Float, startRadius: Float, endRadius: Float) throws -> CGImage {
        guard let device else {
            throw MetalVariableBlurError.cannotCreateDevice
        }
        
        guard
            let inputTexture = makeInputTexture(withImage: image),
            let outputTexture = makeOutputTexture(forImage: image)
        else {
            throw MetalVariableBlurError.cannotMakeTexture
        }
        
//        #if DEBUG
//        triggerProgrammaticCapture(device: device)
//        #endif
        
        guard let variableBlurVerticalFunction else {
            throw MetalVariableBlurError.cannotPrecompileMetalFunction
        }
        
        let width = image.width
        let height = image.height
        
        try variableBlurVerticalFunction.perform(
            numWidth: width,
            numHeight: height
        ) { commandEncoder in
            commandEncoder.setTexture(inputTexture, index: 0)
            
            commandEncoder.setTexture(outputTexture, index: 1)
            
            // Start point
            var startPoint = startPoint
            let startPointBuffer = device.makeBuffer(bytes: &startPoint, length: MemoryLayout<Float>.size)
            commandEncoder.setBuffer(startPointBuffer, offset: 0, index: 0)
            
            // End point
            var endPoint = endPoint
            let endPointBuffer = device.makeBuffer(bytes: &endPoint, length: MemoryLayout<Float>.size)
            commandEncoder.setBuffer(endPointBuffer, offset: 0, index: 1)
            
            // Start radius
            var startRadius = startRadius
            let startRadiusBuffer = device.makeBuffer(bytes: &startRadius, length: MemoryLayout<Float>.size)
            commandEncoder.setBuffer(startRadiusBuffer, offset: 0, index: 2)
            
            // End radius
            var endRadius = endRadius
            let endRadiusBuffer = device.makeBuffer(bytes: &endRadius, length: MemoryLayout<Float>.size)
            commandEncoder.setBuffer(endRadiusBuffer, offset: 0, index: 3)
        }
        
        guard let resultImage = makeImage(fromTexture: outputTexture) else {
            throw MetalVariableBlurError.cannotMakeFinalImage
        }
        
        return resultImage
    }
    
    private func makeInputTexture(withImage image: CGImage) -> MTLTexture? {
        guard let device else {
            return nil
        }
        
        let width = image.width
        let height = image.height
        
        guard let texture = MetalFunction.makeTexture(width: width, height: height, device: device) else {
            return nil
        }
        
        guard
            let imageData = image.dataProvider?.data,
            let imageBytes = CFDataGetBytePtr(imageData)
        else {
            return nil
        }
        
        texture.replace(
            region: MTLRegion(
                origin: MTLOrigin(x: 0, y: 0, z: 0),
                size: MTLSize(width: width, height: height, depth: 1)
            ),
            mipmapLevel: 0,
            withBytes: imageBytes,
            bytesPerRow: image.bytesPerRow
        )
        
        return texture
    }
    
    private func makeOutputTexture(forImage image: CGImage) -> MTLTexture? {
        guard let device else {
            return nil
        }
        
        return MetalFunction.makeTexture(width: image.width, height: image.height, device: device)
    }
    
    private func makeImage(fromTexture texture: MTLTexture) -> CGImage? {
        let context = CGContext(
            data: nil,
            width: texture.width,
            height: texture.height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        
        guard
            let context,
            let imageBytes = context.data
        else {
            return nil
        }
        
        texture.getBytes(
            imageBytes,
            bytesPerRow: context.bytesPerRow,
            from: MTLRegion(
                origin: MTLOrigin(x: 0, y: 0, z: 0),
                size: MTLSize(width: texture.width, height: texture.height, depth: 1)
            ),
            mipmapLevel: 0
        )
        
        return context.makeImage()
    }
    
    private func triggerProgrammaticCapture(device: MTLDevice) {
        let captureManager = MTLCaptureManager.shared()
        let captureDescriptor = MTLCaptureDescriptor()
        captureDescriptor.captureObject = self.device
        captureDescriptor.destination = .developerTools
        do {
            try captureManager.startCapture(with: captureDescriptor)
        } catch {
            fatalError("error when trying to capture: \(error)")
        }
    }
    
    enum MetalVariableBlurError: Error {
        case cannotCreateDevice
        case cannotPrecompileMetalFunction
        case cannotMakeTexture
        case cannotMakeFinalImage
    }
    
}
