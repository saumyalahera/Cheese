//
//  Shaders.metal
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//
#include <metal_stdlib>
using namespace metal;

struct SLColor {
    float4 color;
};

struct SLVertexOut {
    vector_float4 position [[position]];
    vector_float4 color;
};

vertex SLVertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]], constant SLColor &constants [[buffer(1)]]){
    vector_float2 currentVertex = vertexArray[vid];
    SLVertexOut output;
    output.position = vector_float4(currentVertex.x, currentVertex.y, 0, 1);
    float4 colors = constants.color;
    output.color = colors;
    return output;
}

fragment vector_float4 fragmentShader(SLVertexOut interpolated [[stage_in]]){
    return interpolated.color;
}

