import XCTest
import CoreImage
@testable import VariableBlurImageView

final class VariableBlurImageViewTests: XCTestCase {
    
    let variableBlurEngine = VariableBlurEngine()
    
    let bundle = Bundle.module
    
    let testsDirectory = URL(fileURLWithPath: #filePath + "/..").standardizedFileURL.path
    
    let inputImageName = "GreenerOnTheOtherSide"
    
    func testVerticalVariableBlur() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-VerticalBlur-(0,20)-to-(50h,0)",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyVerticalVariableBlur(
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
    
    func testVerticalVariableBlurFromBottom() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-VerticalBlur-(90h,20)-to-(50h,0)",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyVerticalVariableBlur(
                        toImage: input,
                        startPoint: CGFloat(input.height) * 0.9,
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
            _ = try! variableBlurEngine.applyVerticalVariableBlur(
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
                    try variableBlurEngine.applyHorizontalVariableBlur(
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
    
    func testHorizontalVariableBlurFromRight() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-HorizontalBlur-(90w,20)-to-(50w,0)",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyHorizontalVariableBlur(
                        toImage: input,
                        startPoint: CGFloat(input.width) * 0.9,
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
            _ = try! variableBlurEngine.applyHorizontalVariableBlur(
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
                    try variableBlurEngine.applyVariableBlur(
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
            _ = try! variableBlurEngine.applyVariableBlur(
                toImage: inputImage,
                startPoint: CGPoint(x: CGFloat(inputImage.width) * 0.1, y: CGFloat(inputImage.height) * 0.15),
                endPoint: CGPoint(x: CGFloat(inputImage.width) * 0.6, y: CGFloat(inputImage.height) * 0.4),
                startRadius: 20,
                endRadius: 0
            )
        }
    }
    
    func testGradientBlur() throws {
        let gradientImage = try provideInputImage(inputImageName: "TestAlpha")
        
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-GradientBlur-20",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyGradientVariableBlur(
                        toImage: input,
                        withGradient: gradientImage,
                        maxRadius: 20
                    )
                }
            )
        )
    }
    
    func testPerformanceOfGradientBlur() throws {
        let inputImage = try provideInputImage(inputImageName: inputImageName)
        let gradientImage = try provideInputImage(inputImageName: "TestAlpha")
        
        measure {
            _ = try! variableBlurEngine.applyGradientVariableBlur(
                toImage: inputImage,
                withGradient: gradientImage,
                maxRadius: 20
            )
        }
    }
    
    func testMultipleBlurs() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-MultipleBlurs-20",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyMultipleVariableBlurs(
                        toImage: input,
                        withDescriptions: [
                            VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.4), startRadius: 20, endRadius: 0),
                            VariableBlurDescription(startPoint: CGPoint(x: 0, y: CGFloat(input.height)), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.5), startRadius: 20, endRadius: 0),
                        ]
                    )
                }
            )
        )
    }
    
    func testPerformanceOfMultipleBlurs() throws {
        let inputImage = try provideInputImage(inputImageName: inputImageName)
        
        measure {
            _ = try! variableBlurEngine.applyMultipleVariableBlurs(
                toImage: inputImage,
                withDescriptions: [
                    VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: CGFloat(inputImage.height) * 0.4), startRadius: 20, endRadius: 0),
                    VariableBlurDescription(startPoint: CGPoint(x: 0, y: CGFloat(inputImage.height)), endPoint: CGPoint(x: 0, y: CGFloat(inputImage.height) * 0.5), startRadius: 20, endRadius: 0),
                ]
            )
        }
    }
    
    func testMultipleBlursWithOverlap() throws {
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-MultipleBlurs-WithOverlap",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyMultipleVariableBlurs(
                        toImage: input,
                        withDescriptions: [
                            VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.6), startRadius: 20, endRadius: 0),
                            VariableBlurDescription(startPoint: CGPoint(x: 0, y: CGFloat(input.height)), endPoint: CGPoint(x: 0, y: CGFloat(input.height) * 0.4), startRadius: 20, endRadius: 0),
                        ]
                    )
                }
            )
        )
    }
    
    func testVerticalVariableBlurWithAlpha() throws {
        let inputImageName = "TestAlpha"
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-VerticalBlur-(0,20)-to-(50h,0)",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyVerticalVariableBlur(
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
    
    func testHorizontalVariableBlurWithAlpha() throws {
        let inputImageName = "TestAlpha"
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-HorizontalBlur-(0,20)-to-(50w,0)",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyHorizontalVariableBlur(
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
    
    func testVariableBlurWithAlpha() throws {
        let inputImageName = "TestAlpha"
        XCTAssertTrue(
            try isEqual(
                inputImageName: inputImageName,
                expectedImageName: "\(inputImageName)-VariableBlur-((10w,15h),20)-to-((60w,40h),0)",
                afterPerformingImageOperations: { input in
                    try variableBlurEngine.applyVariableBlur(
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
        let producedOutputImage = try image(atPath: producedOutputsPath)
        
        let expectedImagePath = testsDirectory + "/ExpectedOutputs/\(expectedImageName).png"
        let expectedImage = try image(atPath: expectedImagePath)
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let convertedBlurred = convertColorspace(ofImage: producedOutputImage, toColorSpace: colorspace)
        let convertedExpected = convertColorspace(ofImage: expectedImage, toColorSpace: colorspace)
        
        let isEqual = convertedBlurred?.dataProvider?.data == convertedExpected?.dataProvider?.data
        
        if !isEqual {
            print("Image \(String(describing: convertedBlurred)) does not match expected \(String(describing: convertedExpected))")
        }
        
        return isEqual
    }
}
