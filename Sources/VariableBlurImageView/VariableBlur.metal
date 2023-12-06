//
//  VariableBlur.metal
//  Dippel
//
//  Created by Eskil Gjerde Sviggum on 05/12/2023.
//

#include <metal_stdlib>
using namespace metal;

#define M_2xPI_F 6.2831853

float gaussian(float sigma, float x, float y) {
    float var = sigma * sigma;
    float recip = 1 / sigma;
    float expo = exp(-(x * x + y * y) / (2 * var));
    return recip * expo;
}

float lerp(float a, float b, float t) {
    return (1-t) * a + t * b;
}

float3x3 gaussianConvolutionMatrix3x3(float sigma) {
    float3x3 matrix = float3x3(0);
    for (int y = 0; y < 3; y++) {
        for (int x = 0; x < 3; x++) {
            matrix.columns[x][y] = gaussian(sigma, x - 1, y - 1);
        }
    }
    return matrix;
}

kernel void variableBlurVertical(
    texture2d<float, access::read> textureIn [[texture(0)]],
    texture2d<float, access::write> textureOut [[texture(1)]],
    device const float *startPoint     [[buffer(0)]],
    device const float *endPoint       [[buffer(1)]],
    device const float *startRadius    [[buffer(2)]],
    device const float *endRadius      [[buffer(3)]],
    uint2 gid [[thread_position_in_grid]]
) {
    
    float fY = (float)gid.y;
    if (fY < *startPoint || fY >= *endPoint) {
        textureOut.write(textureIn.read(gid), gid);
        return;
    }
    
    float dRange = *endPoint - *startPoint;
    float t = clamp(((float)gid.y - *startRadius) / dRange, 0.0f, 1.0f);
    float radius = lerp(*startRadius, *endRadius, t) + 1;
    
    float3 colorOut = 0;
    
    int matrixSize = (int)ceil(6 * radius);
    int midOffset = matrixSize / 2;
    
    for (int y = 0; y < matrixSize; y++) {
        for (int x = 0; x < matrixSize; x++) {
            int xI = clamp((int)gid.x + x - midOffset, 0, (int)textureIn.get_width() - 1);
            int yI = clamp((int)gid.y + y - midOffset, 0, (int)textureIn.get_height() - 1);
            
            float3 colorIn = textureIn.read(uint2(xI, yI)).xyz;
            float weight = gaussian(radius, x - midOffset, y - midOffset);
            colorOut += colorIn * weight / (float)matrixSize;
        }
    }
    
    textureOut.write(float4(colorOut, 1.0f), gid);
}
