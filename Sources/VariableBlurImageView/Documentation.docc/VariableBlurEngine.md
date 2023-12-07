# ``VariableBlurImageView/VariableBlurEngine``

Apply variable blur to CGImages.

## Overview

You provide a CGImage, start point, end point, and their respective blur radiuses. A new CGImage is returned with the variable blur effect.

### Example

```swift
let variableBlurEngine = VariableBlurEngine()
let leavesImage = UIImage(resource: .leaves)
let blurredImage = variableBlurEngine.applyVerticalVariableBlur(
    toImage: leavesImage, 
    startPoint: 0, 
    endPoint: leavesImage.size.height / 4, 
    startRadius: 15, 
    endRadius: 0
)
```

## Topics

- ``VariableBlurEngine/applyVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyVerticalVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyHorizontalVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
