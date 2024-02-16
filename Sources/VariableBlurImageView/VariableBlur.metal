//
//  VariableBlur.metal
//
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

#include <metal_stdlib>
using namespace metal;

#define M_2xPI 6.2831853h

half gaussian2D(half sigma, half x, half y) {
    half var = sigma * sigma;
    half expo = exp(-(x * x + y * y) / (2.0f * var));
    return expo;
}

half gaussian(half sigma, half x) {
    half var = sigma * sigma;
    half expo = exp(-(x * x) / (2.0h * var));
    return expo;
}

float4 colorForBlurAtPixel(half2 gid, texture2d<float, access::read> textureIn, half radius) {
    float4 colorOut = 0;
    half2 hSize = half2(textureIn.get_width(), textureIn.get_height());
    
    const half fMatrixSize = M_2xPI * radius;
    const int matrixSize = (int)ceil(fMatrixSize);
    const half midOffset = (half)(matrixSize / 2);
    
    half recip = radius * fMatrixSize;
    
    for (int y = 0; y < matrixSize; y++) {
        for (int x = 0; x < matrixSize; x++) {
            ushort xI = (ushort)clamp((half)gid.x + x - midOffset, 0.0h, hSize.x - 1.0h);
            ushort yI = (ushort)clamp((half)gid.y + y - midOffset, 0.0h, hSize.y - 1.0h);
            
            float4 colorIn = textureIn.read(ushort2(xI, yI));
            half weight = gaussian2D(radius, x - midOffset, y - midOffset);
            colorOut += colorIn * weight;
        }
    }
    
    return colorOut / recip;
}

kernel void variableBlurVertical(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    constant float &startPoint     [[buffer(0)]],
    constant float &endPoint       [[buffer(1)]],
    constant float &startRadius    [[buffer(2)]],
    constant float &endRadius      [[buffer(3)]],
    ushort2 gid [[thread_position_in_grid]]
) {
    const half2 hGid = (half2)gid;
    
    half lowestPoint;
    half greatestPoint;
    bool invertT;
    if ((half)startRadius >= (half)endRadius) {
        lowestPoint = endPoint;
        greatestPoint = startPoint;
        invertT = true;
    } else {
        lowestPoint = startPoint;
        greatestPoint = endPoint;
        invertT = false;
    }
    
    half dRange = greatestPoint - lowestPoint;
    half t = (hGid.y - lowestPoint) / dRange;
    
    if (invertT)
        t = 1 - t;
    
    if (t < 0 || t > 1) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half tClamped = clamp(t, 0.0h, 1.0h);
    half radius = max(mix((half)startRadius, (half)endRadius, tClamped), 1.0h);
    
    float4 colorOut = (float4)colorForBlurAtPixel(hGid, textureIn, radius);
    
    textureOut.write(colorOut, gid);
}

kernel void variableBlurHorizontal(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    constant float& startPoint     [[buffer(0)]],
    constant float& endPoint       [[buffer(1)]],
    constant float& startRadius    [[buffer(2)]],
    constant float& endRadius      [[buffer(3)]],
    ushort2 gid [[thread_position_in_grid]]
) {
    const half2 hGid = (half2)gid;
    
    half lowestPoint;
    half greatestPoint;
    bool invertT;
    if ((half)startRadius >= (half)endRadius) {
        lowestPoint = endPoint;
        greatestPoint = startPoint;
        invertT = true;
    } else {
        lowestPoint = startPoint;
        greatestPoint = endPoint;
        invertT = false;
    }
    
    half dRange = greatestPoint - lowestPoint;
    half t = (hGid.x - lowestPoint) / dRange;
    
    if (invertT)
        t = 1 - t;
    
    if (t < 0 || t > 1) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half tClamped = clamp(t, 0.0h, 1.0h);
    half radius = max(mix((half)startRadius, (half)endRadius, tClamped), 1.0h);
    
    float4 colorOut = (float4)colorForBlurAtPixel(hGid, textureIn, radius);
    
    textureOut.write(colorOut, gid);
}

kernel void variableBlur(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    constant float2& startPoint    [[buffer(0)]],
    constant float2& endPoint      [[buffer(1)]],
    constant float& startRadius    [[buffer(2)]],
    constant float& endRadius      [[buffer(3)]],
    ushort2 gid [[thread_position_in_grid]]
) {
    const half2 hGid = (half2)gid;
    
    const half2 hStartPoint = (half2)startPoint;
    const half2 hEndPoint = (half2)endPoint;
    
    half dx = (hEndPoint.x - hStartPoint.x);
    half dy = (hEndPoint.y - hStartPoint.y);
    half angle = atan2(dy, dx);
    half2x2 projmat = half2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
    
    half2 d = projmat * (hGid - hStartPoint);
    
    half dRange = distance(endPoint, startPoint);
    half t = d.x / dRange;
    
    if (t < 0.0h || t > 1.0h) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half tClamped = clamp(t, 0.0h, 1.0h);
    half radius = max(mix((half)startRadius, (half)endRadius, tClamped), 1.0h);
    
    float4 colorOut = (float4)colorForBlurAtPixel(hGid, textureIn, radius);
    
    textureOut.write(colorOut, gid);
}

kernel void gradientVariableBlur(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    texture2d<float, access::read> gradient         [[texture(2)]],
    constant float& maxRadius                       [[buffer(0)]],
    ushort2 gid [[thread_position_in_grid]]
) {
    const half2 hGid = (half2)gid;
    
    const ushort2 gradientGid = ushort2(gid.x % gradient.get_width(), gid.y % gradient.get_height());
    const float4 gradientValue = gradient.read(gradientGid);
    const half luma = ((half)gradientValue.x + (half)gradientValue.y + (half)gradientValue.z) / 3;
    
    half radius = luma * (half)maxRadius;
    
    float4 colorOut;
    
    if (radius >= 1.0h) {
        colorOut = (float4)colorForBlurAtPixel(hGid, textureIn, radius);
    } else {
        colorOut = textureIn.read(gid);
    }
    
    
    textureOut.write(colorOut, gid);
}

struct VariableBlurDescription {
    float2 startPoint;
    float2 endPoint;
    float startRadius;
    float endRadius;
};

kernel void multipleVariableBlur(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    constant struct VariableBlurDescription *descriptions    [[buffer(0)]],
    constant ushort &count      [[buffer(1)]],
    ushort2 gid [[thread_position_in_grid]]
) {
    const half2 hGid = (half2)gid;
    float4 colorOut = 0;
    
    for (ushort i = 0; i < count; i++) {
        const struct VariableBlurDescription description = descriptions[i];
        
        float2 startPoint = description.startPoint;
        float2 endPoint = description.endPoint;
        
        const half2 hStartPoint = (half2)startPoint;
        const half2 hEndPoint = (half2)endPoint;
        
        half dx = (hEndPoint.x - hStartPoint.x);
        half dy = (hEndPoint.y - hStartPoint.y);
        half angle = atan2(dy, dx);
        half2x2 projmat = half2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
        
        half2 d = projmat * (hGid - hStartPoint);
        
        half dRange = distance(endPoint, startPoint);
        half t = d.x / dRange;
        
        if (t < 0.0h || t > 1.0h) {
            if (i == 0)
                colorOut = textureIn.read(gid);
            continue;
        }
        
        half tClamped = clamp(t, 0.0h, 1.0h);
        half radius = max(mix((half)description.startRadius, (half)description.endRadius, tClamped), 1.0h);
        
        colorOut = (float4)colorForBlurAtPixel(hGid, textureIn, radius);
    }
    
    textureOut.write(colorOut, gid);
}
