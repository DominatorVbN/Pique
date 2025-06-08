#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 noise(
    float2   position,
    half4    currentColor,
    float    blockSize
) {
    float2 cell = floor(position / blockSize);
    float value = fract(sin(dot(cell,
                                float2(12.9898, 78.233)))
                        * 43758.5453);
    half3 rgb = currentColor.rgb * half3(value);
    return half4(rgb, currentColor.a);
}
