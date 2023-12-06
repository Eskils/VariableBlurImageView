import XCTest
import UniformTypeIdentifiers
import CoreImage
@testable import VariableBlurImageView

final class VariableBlurImageViewTests: XCTestCase {
    
    let variableBlur = VariableBlur()
    
    let bundle = Bundle.module
    
    let testsDirectory = URL(fileURLWithPath: #filePath + "/..").standardizedFileURL.path
    
    let inputImageName = "GreenerOnTheOtherSide"
    
    func testVerticalVariableBlur() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-VerticalBlur-(0,20)-to-(50h,0)",
                afterPerformingImageOperations: { input in
                    try variableBlur.applyVerticalVariableBlur(
                        toImage: input,
                        startPoint: 0,
                        endPoint: CGFloat(input.height / 2),
                        startRadius: 20,
                        endRadius: 0
                    )
                }
            )
        )
    }
    
    func testPerformanceOfVerticalVariableBlur() throws {
        let inputImage = try provideInputImage(inputImageName: inputImageName)
        measure {
            _ = try! variableBlur.applyVerticalVariableBlur(
                toImage: inputImage,
                startPoint: 0,
                endPoint: CGFloat(inputImage.height / 2),
                startRadius: 20,
                endRadius: 0
            )
        }
    }
    
    func testHorizontalVariableBlur() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-HorizontalBlur-(0,20)-to-(50w,0)",
                afterPerformingImageOperations: { input in
                    try variableBlur.applyHorizontalVariableBlur(
                        toImage: input,
                        startPoint: 0,
                        endPoint: CGFloat(input.width / 2),
                        startRadius: 20,
                        endRadius: 0
                    )
                }
            )
        )
    }
    
    func testPerformanceOfHorizontalVariableBlur() throws {
        let inputImage = try provideInputImage(inputImageName: inputImageName)
        measure {
            _ = try! variableBlur.applyHorizontalVariableBlur(
                toImage: inputImage,
                startPoint: 0,
                endPoint: CGFloat(inputImage.width / 2),
                startRadius: 20,
                endRadius: 0
            )
        }
    }
    
    func testVariableBlur() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-VariableBlur-((10w,15h),20)-to-((60w,40h),0)",
                afterPerformingImageOperations: { input in
                    try variableBlur.applyVariableBlur(
                        toImage: input,
                        startPoint: CGPoint(x: CGFloat(input.width) * 0.1, y: CGFloat(input.height) * 0.15),
                        endPoint: CGPoint(x: CGFloat(input.width) * 0.6, y: CGFloat(input.height) * 0.4),
                        startRadius: 20,
                        endRadius: 0
                    )
                }
            )
        )
    }
    
    func testPerformanceOfVariableBlur() throws {
        let inputImage = try provideInputImage(inputImageName: inputImageName)
        measure {
            _ = try! variableBlur.applyVariableBlur(
                toImage: inputImage,
                startPoint: CGPoint(x: CGFloat(inputImage.width) * 0.1, y: CGFloat(inputImage.height) * 0.15),
                endPoint: CGPoint(x: CGFloat(inputImage.width) * 0.6, y: CGFloat(inputImage.height) * 0.4),
                startRadius: 20,
                endRadius: 0
            )
        }
    }
    
}

extension VariableBlurImageViewTests {
    
    private func provideInputImage(inputImageName: String) throws -> CGImage {
        let inputImagePath = testsDirectory + "/InputImages/\(inputImageName).png"
        let inputImage = try image(atPath: inputImagePath)
        return inputImage
    }
    
    private func isEqual(inputImageName: String, expectedImageName: String, afterPerformingImageOperations block: (CGImage) throws -> CGImage) throws -> Bool {
        let inputImage = try provideInputImage(inputImageName: inputImageName)
        let blurredImage = try block(inputImage)
        
        let producedOutputsPath = testsDirectory + "/ProducedOutputs/\(expectedImageName).png"
        try write(image: blurredImage, toPath: producedOutputsPath)
        
        let expectedImagePath = testsDirectory + "/ExpectedOutputs/\(expectedImageName).png"
        let expectedImage = try image(atPath: expectedImagePath)
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let convertedBlurred = convertColorspace(ofImage: blurredImage, toColorSpace: colorspace)
        let convertedExpected = convertColorspace(ofImage: expectedImage, toColorSpace: colorspace)
        
        return convertedBlurred?.dataProvider?.data == convertedExpected?.dataProvider?.data
    }
    
    func convertColorspace(ofImage image: CGImage, toColorSpace colorSpace: CGColorSpace) -> CGImage? {
        let rect = CGRect(origin: .zero, size: CGSize(width: image.width, height: image.height))
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue))
        let context = CGContext(data: nil, width: Int(rect.width), height: Int(rect.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        context.draw(image, in: rect)
        let image = context.makeImage()
        return image
    }
    
    private func image(atPath path: String) throws -> CGImage {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            throw TestsError.cannotMakeImageSource
        }
        guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
            throw TestsError.cannotMakeCGImageFromData
        }
        
        return cgImage
    }
    
    private func write(image: CGImage, toPath path: String) throws {
        let data = NSMutableData()
        guard
            let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, UTType.png.identifier as CFString, 1, nil)
        else {
            throw TestsError.cannotMakeImageDestination
        }
        
        CGImageDestinationAddImage(imageDestination, image, nil)
        
        CGImageDestinationFinalize(imageDestination)
        
        data.write(toFile: path, atomically: true)
    }
    
    enum TestsError: Error {
        case cannotFindImageResource
        case cannotMakeImageSource
        case cannotMakeCGImageFromData
        case cannotMakeImageDestination
    }
}
