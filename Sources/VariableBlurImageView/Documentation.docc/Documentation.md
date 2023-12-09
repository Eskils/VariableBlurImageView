# ``VariableBlurImageView``

Add variable blur to images in UIKit, AppKit, and SwiftUI. Works on Apple platforms using Metal.

## Overview

This frameworks provides subclasses for UIImageView, and NSImageView, in addition to SwiftUI views and modifiers to apply variable blur to images.

There is also a class to apply variable blur to CGImages.

![iOS app with a vertical variable blur from the top to the middle](iOSAppDemo1.png)

### Possible kinds
 
| Vertical | Horizontal | Between two points | Gradient | Multiple blurs |
|----------|------------|--------------------|----------|----------------|
![Vertical progressive blur](VariableBlurTestImage-VerticalBlur.png) | ![Horizontal progressive blur](VariableBlurTestImage-HorizontalBlur.png) | ![Progressive blur between two points](VariableBlurTestImage-VariableBlur.png) | ![Progressive blur from the lightness in a gradient image](VariableBlurTestImage-GradientBlur.png) | ![Multiple progressive blurs](VariableBlurTestImage-MultipleBlurs.png)

## Topics

### Working in UIKit or AppKit

- ``VariableBlurImageView/VariableBlurImageView/variableBlur(image:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurImageView/VariableBlurImageView/verticalVariableBlur(image:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurImageView/VariableBlurImageView/horizontalVariableBlur(image:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurImageView/VariableBlurImageView/gradientBlur(image:gradientImage:maxRadius:)``
- ``VariableBlurImageView/VariableBlurImageView/multipleBlurs(image:descriptions:)``

### SwiftUI Views
- ``VerticalVariableBlurImage``
- ``HorizontalVariableBlurImage``
- ``VariableBlurImage``
- ``GradientBlurImage``
- ``MultipleBlursImage``

### SwiftUI Modifiers (iOS 16.0+, macOS 13.0+)
- ``SwiftUI/Image/verticalVariableBlur(startPoint:endPoint:startRadius:endRadius:)``
- ``SwiftUI/Image/horizontalVariableBlur(startPoint:endPoint:startRadius:endRadius:)``
- ``SwiftUI/Image/variableBlur(startPoint:endPoint:startRadius:endRadius:)``
- ``SwiftUI/Image/gradientBlur(gradientImage:maxRadius:)``
- ``SwiftUI/Image/mutlipleBlurs(descriptions:)``

### Applying variable blur to CGImages

- ``VariableBlurEngine/applyVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyVerticalVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyHorizontalVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyGradientVariableBlur(toImage:withGradient:maxRadius:)``
- ``VariableBlurEngine/applyMultipleVariableBlurs(toImage:withDescriptions:)``
