//
//  main.swift
//
//
//  Created by Eskil Gjerde Sviggum on 06/12/2023.
//

import Foundation
import CoreGraphics

let arguments = GenerateTestImages.parseArguments(CommandLine.arguments)

let projectDirectory = URL(fileURLWithPath: #filePath + "/../../../").standardizedFileURL.path + "/"

guard let inputPath = arguments["input"]?.replacingOccurrences(of: "./", with: projectDirectory) else {
    print("Please provide a valid input directory with the “-input” argument.")
    exit(-1)
}
let inputURL = URL(fileURLWithPath: inputPath)

guard let outputPath = arguments["output"]?.replacingOccurrences(of: "./", with: projectDirectory) else {
    print("Please provide a valid output path with the “-output” argument.")
    exit(-1)
}
let outputURL = URL(fileURLWithPath: outputPath)

let generateImages = GenerateImages()

var outputImages = [OutputImage]()

let inputDirectoryItems = try FileManager.default.contentsOfDirectory(atPath: inputPath)

for inputItem in inputDirectoryItems {
    if inputItem.starts(with: ".") {
        continue
    }
    
    do {
        let inputPath = inputURL.appendingPathComponent(inputItem).path
        let inputImage = try GenerateTestImages.image(atPath: inputPath)
        let name = URL(fileURLWithPath: inputItem).lastPathComponent.split(separator: ".")[0]
        generateImages.imageTransforms(inputImage: inputImage, name: String(name), outputImages: &outputImages)
    } catch {
        print("Could not handle \(inputItem). Error: \(error)")
    }
}

outputImages.forEach { output in
    let path = outputURL.appendingPathComponent(output.name + ".png").path
    do {
        try GenerateTestImages.write(image: output.image, toPath: path)
    } catch {
        print("Could not write image \(output.name) to \(path).")
    }
}
