//
//  ImageTilerTests.swift
//
//
//  Created by Eskil Gjerde Sviggum on 07/12/2023.
//

import XCTest
@testable import VariableBlurImageView

final class ImageTilerTests: XCTestCase {
    
    let testsDirectory = URL(fileURLWithPath: #filePath + "/..").standardizedFileURL.path
    
    static let imageSize = CGSize(width: 100, height: 200)
    let image1 = CIContext().createCGImage(CIImage(color: .blue), from: CGRect(origin: .zero, size: imageSize))!
    let image2 = CIContext().createCGImage(CIImage(color: .red), from: CGRect(origin: .zero, size: imageSize))!
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    func testImageTilerHorizontal() throws {
        let imageTiler = ImageTiler(tileMode: .horizontal)
        
        guard let tiledImage = imageTiler.tile(images: [image1, image2]) else {
            XCTFail("Cannot create tiled image")
            return
        }
        
        let expectedImageName = "tiledImageHorizontal"
        let expectedImagePath = testsDirectory + "/ExpectedOutputs/\(expectedImageName).png"
        let expectedImage = try image(atPath: expectedImagePath)
        
        let convertedTiled = convertColorspace(ofImage: tiledImage, toColorSpace: colorSpace)
        let convertedExpected = convertColorspace(ofImage: expectedImage, toColorSpace: colorSpace)
        
        XCTAssertTrue(convertedTiled?.dataProvider?.data == convertedExpected?.dataProvider?.data)
    }
    
    func testImageTilerVertical() throws {
        let imageTiler = ImageTiler(tileMode: .vertical)
        
        guard let tiledImage = imageTiler.tile(images: [image1, image2]) else {
            XCTFail("Cannot create tiled image")
            return
        }
        
        let expectedImageName = "tiledImageVertical"
        let expectedImagePath = testsDirectory + "/ExpectedOutputs/\(expectedImageName).png"
        let expectedImage = try image(atPath: expectedImagePath)
        
        let convertedTiled = convertColorspace(ofImage: tiledImage, toColorSpace: colorSpace)
        let convertedExpected = convertColorspace(ofImage: expectedImage, toColorSpace: colorSpace)
        
        XCTAssertTrue(convertedTiled?.dataProvider?.data == convertedExpected?.dataProvider?.data)
    }
    
    func testImageTilerGetComponentImagesHorizontal() throws {
        let imageTiler = ImageTiler(tileMode: .horizontal)
        
        let tiledImageName = "tiledImageHorizontal"
        let tiledImagePath = testsDirectory + "/ExpectedOutputs/\(tiledImageName).png"
        let tiledImage = try image(atPath: tiledImagePath)
        
        let componentImages = imageTiler.getComponentImages(image: tiledImage, desiredSize: Self.imageSize)
        
        if componentImages.count != 2 {
            XCTFail("Component Images returned incorrect number of images")
        }
        
        let image1Component = convertColorspace(ofImage: componentImages[0], toColorSpace: colorSpace)
        let image2Component = convertColorspace(ofImage: componentImages[1], toColorSpace: colorSpace)
        let convertedImage1 = convertColorspace(ofImage: image1, toColorSpace: colorSpace)
        let convertedImage2 = convertColorspace(ofImage: image2, toColorSpace: colorSpace)
        
        XCTAssertTrue(image1Component?.dataProvider?.data == convertedImage1?.dataProvider?.data)
        XCTAssertTrue(image2Component?.dataProvider?.data == convertedImage2?.dataProvider?.data)
    }
    
    func testImageTilerGetComponentImagesVertical() throws {
        let imageTiler = ImageTiler(tileMode: .vertical)
        
        let tiledImageName = "tiledImageVertical"
        let tiledImagePath = testsDirectory + "/ExpectedOutputs/\(tiledImageName).png"
        let tiledImage = try image(atPath: tiledImagePath)
        
        let componentImages = imageTiler.getComponentImages(image: tiledImage, desiredSize: Self.imageSize)
        
        if componentImages.count != 2 {
            XCTFail("Component Images returned incorrect number of images")
        }
        
        let image1Component = convertColorspace(ofImage: componentImages[0], toColorSpace: colorSpace)
        let image2Component = convertColorspace(ofImage: componentImages[1], toColorSpace: colorSpace)
        let expectedImage1 = convertColorspace(ofImage: image1, toColorSpace: colorSpace)
        let expectedImage2 = convertColorspace(ofImage: image2, toColorSpace: colorSpace)
        
        XCTAssertTrue(image1Component?.dataProvider?.data == expectedImage1?.dataProvider?.data)
        XCTAssertTrue(image2Component?.dataProvider?.data == expectedImage2?.dataProvider?.data)
    }
    
    func testImageTilerHorizontalIntegration() {
        let imageTiler = ImageTiler(tileMode: .horizontal)
        
        guard let tiledImage = imageTiler.tile(images: [image1, image2]) else {
            XCTFail("Cannot create tiled image")
            return
        }
        
        let componentImages = imageTiler.getComponentImages(image: tiledImage, desiredSize: Self.imageSize)
        
        if componentImages.count != 2 {
            XCTFail("Component Images returned incorrect number of images")
        }
        
        let image1Component = convertColorspace(ofImage: componentImages[0], toColorSpace: colorSpace)
        let image2Component = convertColorspace(ofImage: componentImages[1], toColorSpace: colorSpace)
        let convertedImage1 = convertColorspace(ofImage: image1, toColorSpace: colorSpace)
        let convertedImage2 = convertColorspace(ofImage: image2, toColorSpace: colorSpace)
        
        XCTAssertTrue(image1Component?.dataProvider?.data == convertedImage1?.dataProvider?.data)
        XCTAssertTrue(image2Component?.dataProvider?.data == convertedImage2?.dataProvider?.data)
    }
    
    func testImageTilerVerticalIntegration() {
        let imageTiler = ImageTiler(tileMode: .vertical)
        
        guard let tiledImage = imageTiler.tile(images: [image1, image2]) else {
            XCTFail("Cannot create tiled image")
            return
        }
        
        let componentImages = imageTiler.getComponentImages(image: tiledImage, desiredSize: Self.imageSize)
        
        if componentImages.count != 2 {
            XCTFail("Component Images returned incorrect number of images")
        }
        
        let image1Component = convertColorspace(ofImage: componentImages[0], toColorSpace: colorSpace)
        let image2Component = convertColorspace(ofImage: componentImages[1], toColorSpace: colorSpace)
        let convertedImage1 = convertColorspace(ofImage: image1, toColorSpace: colorSpace)
        let convertedImage2 = convertColorspace(ofImage: image2, toColorSpace: colorSpace)
        
        XCTAssertTrue(image1Component?.dataProvider?.data == convertedImage1?.dataProvider?.data)
        XCTAssertTrue(image2Component?.dataProvider?.data == convertedImage2?.dataProvider?.data)
    }
    
}
