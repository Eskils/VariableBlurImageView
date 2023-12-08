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
    
    const half fMatrixSize = M_2xPI * radius;
    const int matrixSize = (int)ceil(fMatrixSize);
    const half midOffset = (half)(matrixSize / 2);
    
    half recip = 1 / (radius * fMatrixSize);
    
    for (int y = 0; y < matrixSize; y++) {
        for (int x = 0; x < matrixSize; x++) {
            ushort xI = (ushort)clamp((half)gid.x + x - midOffset, 0.0h, (half)textureIn.get_width() - 1.0h);
            ushort yI = (ushort)clamp((half)gid.y + y - midOffset, 0.0h, (half)textureIn.get_height() - 1.0h);
            
            float4 colorIn = textureIn.read(ushort2(xI, yI));
            half weight = gaussian2D(radius, x - midOffset, y - midOffset);
            colorOut += colorIn * weight;
        }
    }
    
    return recip * colorOut;
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
    half2 hGid = (half2)gid;
    
    if (hGid.y < startPoint || hGid.y >= endPoint) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half dRange = endPoint - startPoint;
    half t = clamp((hGid.y - (half)startRadius) / dRange, 0.0h, 1.0h);
    half radius = max(mix((half)startRadius, (half)endRadius, t), 1.0h);
    
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
    
    half2 hGid = (half2)gid;
    if (hGid.x < startPoint || hGid.x >= endPoint) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half dRange = endPoint - startPoint;
    half t = clamp((hGid.x - (half)startRadius) / dRange, 0.0h, 1.0h);
    half radius = max(mix((half)startRadius, (half)endRadius, t), 1.0h);
    
    float4 colorOut = (float4)colorForBlurAtPixel(hGid, textureIn, radius);
    
    textureOut.write(colorOut, gid);
}

half2 normalOfGradient(half2 gradient) {
    return half2(gradient.y, -gradient.x);
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
    half2 hGid = (half2)gid;
    half2 hStartPoint = (half2)startPoint;
    half2 hEndPoint = (half2)endPoint;
    
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
