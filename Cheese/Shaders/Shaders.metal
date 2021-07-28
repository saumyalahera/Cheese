//
//  Shaders.metal
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//
#include <metal_stdlib>
using namespace metal;

struct Constants {
    float4 color;
};

struct VertexOut {
    vector_float4 position [[position]];
    vector_float4 color;
};


vertex VertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]], constant Constants &constants [[buffer(1)]]){
    vector_float2 currentVertex = vertexArray[vid];
    //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
    VertexOut output;
    output.position = vector_float4(currentVertex.x, currentVertex.y, 0, 1);
    //populate the output position with the x and y values of our input vertex data
    float4 colors = constants.color;
    output.color = colors;
    return output;
}

fragment vector_float4 fragmentShader(VertexOut interpolated [[stage_in]]){
    
    /*float d = distance(interpolated.position.xyz, float3(0,0,0));
      float radius = 0.2;
      float soften = 1;
      float final = (1 - d / radius) / soften;
      return float4(final, 0, 0, final);*/
    
    return interpolated.color;
}

