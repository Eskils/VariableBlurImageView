//
//  OutputImage.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import Foundation
import CoreGraphics

struct OutputImage {
    let name: String
    let image: CGImage
    
    static func from(image: CGImage, named name: String, performingOperations block: (CGImage) throws -> CGImage) -> Self? {
        do {
            let output = try block(image)
            return OutputImage(name: name, image: output)
        } catch {
            print("Failed to make \(name). Error: \(error)")
            return nil
        }
    }
    
    func adding(to array: inout [OutputImage]) {
        array.append(self)
    }
}
