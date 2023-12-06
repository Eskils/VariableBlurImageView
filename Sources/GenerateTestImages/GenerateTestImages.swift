//
//  GenerateTestImages.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import Foundation
import CoreGraphics
import ImageIO
import VariableBlurImageView

struct GenerateTestImages {
    private init() {}
    
    static func image(atPath path: String) throws -> CGImage {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            throw GenerateTestImagesError.cannotMakeImageSource
        }
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            throw GenerateTestImagesError.cannotMakeCGImageFromData
        }
        
        return cgImage
    }

    static func write(image: CGImage, toPath path: String) throws {
        let data = NSMutableData()
        guard
            let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, "public.png" as CFString, 1, nil)
        else {
            throw GenerateTestImagesError.cannotMakeImageDestination
        }
        
        CGImageDestinationAddImage(imageDestination, image, nil)
        
        CGImageDestinationFinalize(imageDestination)
        
        data.write(toFile: path, atomically: true)
    }
    
    static func parseArguments(_ arguments: [String]) -> [String: String] {
        var result = [String: String]()
        var arguments = arguments
        
        while !arguments.isEmpty {
            var arg = arguments.removeFirst()
            // Check if is value, continue if is
            if arg.removeFirst() != "-" {
                continue
            }
            
            // Check if argument has a value, continue if not
            if arguments.isEmpty {
                continue
            }
            
            let value = arguments.removeFirst()
            
            // Check if value is an argument, continue if is
            if value.starts(with: "-") {
                continue
            }
            
            result[arg] = value
        }
        
        return result
    }
    
}

extension GenerateTestImages {
    enum GenerateTestImagesError: Error {
        case cannotFindImageResource
        case cannotMakeImageSource
        case cannotMakeCGImageFromData
        case cannotMakeImageDestination
    }
}
