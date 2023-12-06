//
//  VariableBlur.metal
//
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

#include <metal_stdlib>
using namespace metal;

#define M_2xPI 6.2831853

half gaussian2D(half sigma, half x, half y) {
    half var = sigma * sigma;
    half expo = exp(-(x * x + y * y) / (2 * var));
    return expo;
}

half gaussian(half sigma, half x) {
    half var = sigma * sigma;
    half expo = exp(-(x * x) / (2 * var));
    return expo;
}

half lerp(half a, half b, half t) {
    return (1-t) * a + t * b;
}

float3 colorForBlurAtPixel(uint2 gid, texture2d<float, access::read> textureIn, float radius) {
    float3 colorOut = 0;
    
    float fMatrixSize = M_2xPI * radius;
    const int matrixSize = (int)ceil(fMatrixSize);
    int midOffset = matrixSize / 2;
    
    half recip = 1 / (radius * fMatrixSize);
    
    for (int y = 0; y < matrixSize; y++) {
        for (int x = 0; x < matrixSize; x++) {
            int xI = clamp((int)gid.x + x - midOffset, 0, (int)textureIn.get_width() - 1);
            int yI = clamp((int)gid.y + y - midOffset, 0, (int)textureIn.get_height() - 1);
            
            float3 colorIn = textureIn.read(uint2(xI, yI)).xyz;
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
    uint2 gid [[thread_position_in_grid]]
) {
    
    half fY = (half)gid.y;
    if (fY < startPoint || fY >= endPoint) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half dRange = endPoint - startPoint;
    half t = clamp(((half)gid.y - (half)startRadius) / dRange, 0.0h, 1.0h);
    half radius = max(lerp(startRadius, endRadius, t), 1.0h);
    
    float3 colorOut = colorForBlurAtPixel(gid, textureIn, radius);
    
    textureOut.write(float4(colorOut, 1.0f), gid);
}

kernel void variableBlurHorizontal(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    constant float& startPoint     [[buffer(0)]],
    constant float& endPoint       [[buffer(1)]],
    constant float& startRadius    [[buffer(2)]],
    constant float& endRadius      [[buffer(3)]],
    uint2 gid [[thread_position_in_grid]]
) {
    
    half fX = (half)gid.x;
    if (fX < startPoint || fX >= endPoint) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half dRange = endPoint - startPoint;
    half t = clamp(((half)gid.x - (half)startRadius) / dRange, 0.0h, 1.0h);
    half radius = max(lerp(startRadius, endRadius, t), 1.0h);
    
    float3 colorOut = colorForBlurAtPixel(gid, textureIn, radius);
    
    textureOut.write(float4(colorOut, 1.0f), gid);
}

kernel void variableBlur(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    constant float2& startPoint    [[buffer(0)]],
    constant float2& endPoint      [[buffer(1)]],
    constant float& startRadius    [[buffer(2)]],
    constant float& endRadius      [[buffer(3)]],
    uint2 gid [[thread_position_in_grid]]
) {
    half dx = (endPoint.x - startPoint.x);
    half dy = (endPoint.y - startPoint.y);
    half angle = atan2(dy, dx);
    half2x2 projmat = half2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
    
    half2 d = projmat * ((half2)gid - (half2)startPoint);
    
    half dRange = (half)distance(endPoint, startPoint);
    half t = d.x / dRange;
    
    if (t < 0 || t > 1) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    half tClamped = clamp(t, 0.0h, 1.0h);
    half radius = max(lerp(startRadius, endRadius, tClamped), 1.0h);
    
    float3 colorOut = colorForBlurAtPixel(gid, textureIn, radius);
    
    textureOut.write(float4(colorOut, 1.0f), gid);
}
