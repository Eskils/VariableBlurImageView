# ``VariableBlurImageView``

Add variable blur to images on iOS and MacCatalyst. Works with UIKit using Metal.

## Overview

This frameworks provides an UIImageView subclass and a class to apply variable blur to CGImages.

![iOS app with a vertical variable blur from the top to the middle](iOSAppDemo1.png)
 
#### Vertical  
![Vertical progressive blur](VariableBlurTestImage-VerticalBlur.png)

#### Horizontal  
![Horizontal progressive blur](VariableBlurTestImage-HorizontalBlur.png)

#### Between two points  
![Progressive blur between two points](VariableBlurTestImage-VariableBlur.png)

## Topics

### Variable blur ImageView

- ``VariableBlurImageView/VariableBlurImageView/variableBlur(image:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurImageView/VariableBlurImageView/verticalVariableBlur(image:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurImageView/VariableBlurImageView/horizontalVariableBlur(image:startPoint:endPoint:startRadius:endRadius:)``

### Applying variable blur to images

- ``VariableBlurEngine/applyVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyVerticalVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
- ``VariableBlurEngine/applyHorizontalVariableBlur(toImage:startPoint:endPoint:startRadius:endRadius:)``
