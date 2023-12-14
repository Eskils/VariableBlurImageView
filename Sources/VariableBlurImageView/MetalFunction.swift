//
//  MetalFunction.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import Metal

struct MetalFunction {
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLComputePipelineState
    let maxThreads: Int
    
    static func precompileMetalFunction(withName functionName: String, device: MTLDevice) throws -> MetalFunction {
        let bundle = Bundle.module
        let library = try device.makeDefaultLibrary(bundle: bundle)
        
        guard let function = library.makeFunction(name: functionName) else {
            throw PrecompieMetalError.cannotMakeMetalFunction
        }
        
        guard let commandQueue = device.makeCommandQueue() else {
            throw PrecompieMetalError.canotMakeCommandQueue
        }
        
        let pipelineState = try device.makeComputePipelineState(function: function)
        
        let maxThreadsPerThreadgroup = device.maxThreadsPerThreadgroup
        let maxThreads = Int(sqrt(Float(maxThreadsPerThreadgroup.width)))
        
        return MetalFunction(commandQueue: commandQueue, pipelineState: pipelineState, maxThreads: maxThreads)
    }
    
    static func makeTexture(width: Int, height: Int, device: MTLDevice, usage: MTLTextureUsage, storageMode: MTLStorageMode) -> MTLTexture? {
        let descriptor = MTLTextureDescriptor()
        descriptor.width = width
        descriptor.height = height
        descriptor.textureType = .type2D
        descriptor.pixelFormat = .rgba8Unorm
        descriptor.storageMode = storageMode
        descriptor.usage = usage
        return device.makeTexture(descriptor: descriptor)
    }
    
    func perform(numWidth: Int, numHeight: Int, commandEncoderConfiguration: @escaping (_ commandEncoder: MTLComputeCommandEncoder,_ threadgroups: MTLSize) -> Void) throws {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            throw PerformMetalError.cannotMakeCommandBuffer
        }
        
        guard let commandEncoder = commandBuffer.makeComputeCommandEncoder() else {
            throw PerformMetalError.cannotMakeCommandEncoder
        }
        
        commandEncoder.setComputePipelineState(pipelineState)
        
        let threadsPerThreadgroup = MTLSizeMake(min(maxThreads, numWidth), min(maxThreads, numHeight), 1)
        let threadgroups = MTLSizeMake((numWidth - 1) / threadsPerThreadgroup.width + 1, (numHeight - 1) / threadsPerThreadgroup.height + 1, 1)
        
        commandEncoderConfiguration(commandEncoder, threadgroups)
        
        commandEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadsPerThreadgroup)
        commandEncoder.endEncoding()
        
        commandBuffer.commit()
        #if DEBUG
        let captureManager = MTLCaptureManager.shared()
        if captureManager.isCapturing {
            captureManager.stopCapture()
        }
        #endif
        commandBuffer.waitUntilCompleted()
    }
    
    enum PrecompieMetalError: Error {
        case cannotMakeMetalLibrary
        case cannotMakeMetalFunction
        case canotMakeCommandQueue
    }
    
    enum PerformMetalError: Error {
        case cannotMakeCommandBuffer
        case cannotMakeCommandEncoder
        case cannotMakeBlitCommandEncoder
    }
}
