//
//  VariableBlurMetal.swift
//
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

import CoreGraphics
import Metal

class VariableBlurMetal {
    
    private lazy var device = MTLCreateSystemDefaultDevice()
    
    private static let variableBlurVerticalFunctionName = "variableBlurVertical"
    private lazy var variableBlurVerticalFunction: MetalFunction? = {
        device.flatMap {
            do {
                return try MetalFunction.precompileMetalFunction(withName: Self.variableBlurVerticalFunctionName, device: $0)
            } catch {
                #if DEBUG
                print("Cannot precompile metal function with error: \(error)")
                #endif
                return nil
            }
        }
    }()
    
    private static let variableBlurHorizontalFunctionName = "variableBlurHorizontal"
    private lazy var variableBlurHorizontalFunction: MetalFunction? = {
        device.flatMap {
            do {
                return try MetalFunction.precompileMetalFunction(withName: Self.variableBlurHorizontalFunctionName, device: $0)
            } catch {
                #if DEBUG
                print("Cannot precompile metal function with error: \(error)")
                #endif
                return nil
            }
        }
    }()
    
    private static let variableBlurFunctionName = "variableBlur"
    private lazy var variableBlurFunction: MetalFunction? = {
        device.flatMap {
            do {
                return try MetalFunction.precompileMetalFunction(withName: Self.variableBlurFunctionName, device: $0)
            } catch {
                #if DEBUG
                print("Cannot precompile metal function with error: \(error)")
                #endif
                return nil
            }
        }
    }()
    
    lazy var sizeBuffer         = device?.makeBuffer(length: MemoryLayout<SIMD2<UInt16>>.size)
    lazy var startPoint1DBuffer = device?.makeBuffer(length: MemoryLayout<Float>.size)
    lazy var endPoint1DBuffer   = device?.makeBuffer(length: MemoryLayout<Float>.size)
    lazy var startPoint2DBuffer = device?.makeBuffer(length: MemoryLayout<SIMD2<Float>>.size)
    lazy var endPoint2DBuffer   = device?.makeBuffer(length: MemoryLayout<SIMD2<Float>>.size)
    lazy var startRadiusBuffer  = device?.makeBuffer(length: MemoryLayout<Float>.size)
    lazy var endRadiusBuffer    = device?.makeBuffer(length: MemoryLayout<Float>.size)
    
    private func variableBlurGeneric(_ function: MetalFunction?, image: CGImage, bufferConfigurationHandler: @escaping (MTLDevice, MTLComputeCommandEncoder) -> Void) throws -> CGImage {
        guard let device, let sizeBuffer else {
            throw MetalVariableBlurError.cannotCreateDevice
        }
        
        guard
            let texture = makeInputOutputTexture(withImage: image)
        else {
            throw MetalVariableBlurError.cannotMakeTexture
        }
        
//        #if DEBUG
//        triggerProgrammaticCapture(device: device)
//        #endif
        
        guard let function else {
            throw MetalVariableBlurError.cannotPrecompileMetalFunction
        }
        
        let width = image.width
        let height = image.height
        
        try function.perform(
            numWidth: width,
            numHeight: height
        ) { (commandEncoder, threadgroups) in
            commandEncoder.setTexture(texture, index: 0)
            
            sizeBuffer.contents().assumingMemoryBound(to: SIMD2<UInt16>.self).pointee = SIMD2<UInt16>(x: UInt16(image.width), y: UInt16(image.height))
            commandEncoder.setBuffer(sizeBuffer, offset: 0, index: 4)
            
            bufferConfigurationHandler(device, commandEncoder)
        }
        
        guard let resultImage = makeImage(fromTexture: texture, width: width, height: height) else {
            throw MetalVariableBlurError.cannotMakeFinalImage
        }
        
        return resultImage
    }
    
    func variableBlurVertical(image: CGImage, startPoint: Float, endPoint: Float, startRadius: Float, endRadius: Float) throws -> CGImage {
        guard let startPoint1DBuffer, let endPoint1DBuffer, let startRadiusBuffer, let endRadiusBuffer else {
            throw MetalVariableBlurError.cannotCreateDevice
        }
        
        return try variableBlurGeneric(variableBlurVerticalFunction, image: image) { (device, commandEncoder) in
            // Start point
            startPoint1DBuffer.contents().assumingMemoryBound(to: Float.self).pointee = startPoint
            commandEncoder.setBuffer(startPoint1DBuffer, offset: 0, index: 0)
            
            // End point
            endPoint1DBuffer.contents().assumingMemoryBound(to: Float.self).pointee = endPoint
            commandEncoder.setBuffer(endPoint1DBuffer, offset: 0, index: 1)
            
            // Start radius
            startRadiusBuffer.contents().assumingMemoryBound(to: Float.self).pointee = startRadius
            commandEncoder.setBuffer(startRadiusBuffer, offset: 0, index: 2)
            
            // End radius
            endRadiusBuffer.contents().assumingMemoryBound(to: Float.self).pointee = endRadius
            commandEncoder.setBuffer(endRadiusBuffer, offset: 0, index: 3)
        }
    }
    
    func variableBlurHorizontal(image: CGImage, startPoint: Float, endPoint: Float, startRadius: Float, endRadius: Float) throws -> CGImage {
        guard let startPoint1DBuffer, let endPoint1DBuffer, let startRadiusBuffer, let endRadiusBuffer else {
            throw MetalVariableBlurError.cannotCreateDevice
        }
        
        return try variableBlurGeneric(variableBlurHorizontalFunction, image: image) { (device, commandEncoder) in
            // Start point
            startPoint1DBuffer.contents().assumingMemoryBound(to: Float.self).pointee = startPoint
            commandEncoder.setBuffer(startPoint1DBuffer, offset: 0, index: 0)
            
            // End point
            endPoint1DBuffer.contents().assumingMemoryBound(to: Float.self).pointee = endPoint
            commandEncoder.setBuffer(endPoint1DBuffer, offset: 0, index: 1)
            
            // Start radius
            startRadiusBuffer.contents().assumingMemoryBound(to: Float.self).pointee = startRadius
            commandEncoder.setBuffer(startRadiusBuffer, offset: 0, index: 2)
            
            // End radius
            endRadiusBuffer.contents().assumingMemoryBound(to: Float.self).pointee = endRadius
            commandEncoder.setBuffer(endRadiusBuffer, offset: 0, index: 3)
        }
    }
    
    func variableBlur(image: CGImage, startPoint: SIMD2<Float>, endPoint: SIMD2<Float>, startRadius: Float, endRadius: Float) throws -> CGImage {
        guard let startPoint2DBuffer, let endPoint2DBuffer, let startRadiusBuffer, let endRadiusBuffer else {
            throw MetalVariableBlurError.cannotCreateDevice
        }
        
        return try variableBlurGeneric(variableBlurFunction, image: image) { (device, commandEncoder) in
            // Start point
            startPoint2DBuffer.contents().assumingMemoryBound(to: SIMD2<Float>.self).pointee = startPoint
            commandEncoder.setBuffer(startPoint2DBuffer, offset: 0, index: 0)
            
            // End point
            endPoint2DBuffer.contents().assumingMemoryBound(to: SIMD2<Float>.self).pointee = endPoint
            commandEncoder.setBuffer(endPoint2DBuffer, offset: 0, index: 1)
            
            // Start radius
            startRadiusBuffer.contents().assumingMemoryBound(to: Float.self).pointee = startRadius
            commandEncoder.setBuffer(startRadiusBuffer, offset: 0, index: 2)
            
            // End radius
            endRadiusBuffer.contents().assumingMemoryBound(to: Float.self).pointee = endRadius
            commandEncoder.setBuffer(endRadiusBuffer, offset: 0, index: 3)
        }
    }
    
    private func makeInputOutputTexture(withImage image: CGImage) -> MTLTexture? {
        guard let device else {
            return nil
        }
        
        let width = image.width
        let height = image.height
        
        guard let texture = MetalFunction.makeTexture(width: 2 * width, height: height, device: device) else {
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
    
    private func makeImage(fromTexture texture: MTLTexture, width: Int, height: Int) -> CGImage? {
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
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
                origin: MTLOrigin(x: width, y: 0, z: 0),
                size: MTLSize(width: width, height: height, depth: 1)
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
