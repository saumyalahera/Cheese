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

struct SLCanvasDimensions {
    float height;
    float width;
};

struct SLTransformations {
    float4x4 projectionMatrix;
};


vertex SLVertexOut vertexShader(const constant vector_float2 *vertexArray [[buffer(0)]], unsigned int vid [[vertex_id]], constant SLColor &constants [[buffer(1)]], constant SLCanvasDimensions& dimensions [[ buffer(2) ]]){
    vector_float2 currentVertex = vertexArray[vid];
    //fetch the current vertex we're on using the vid to index into our buffer data which holds all of our vertex points that we passed in
    SLVertexOut output;
    output.position = vector_float4(currentVertex.x, currentVertex.y, 0, 1);// * projection.projectionMatrix;
    //populate the output position with the x and y values of our input vertex data
    float4 colors = constants.color;
    output.color = colors;
    
    
    //Vertex out = vertices[vertexId];
    /*SLVertexOut out;
    out.position = vector_float4(currentVertex.x, currentVertex.y, 0, 1);
    out.position.x = 2 * (out.position.x / dimensions.width - 0.5);
    out.position.y = -2 * (out.position.y / dimensions.height - 0.5);
    out.position = vector_float4(out.position.x, out.position.y, 0, 1);
    out.color = colors;
    
    return out;*/
    
    return output;
}

fragment vector_float4 fragmentShader(SLVertexOut interpolated [[stage_in]]){
    
    /*float d = distance(interpolated.position.xyz, float3(0,0,0));
      float radius = 0.2;
      float soften = 1;
      float final = (1 - d / radius) / soften;
      return float4(final, 0, 0, final);*/
    
    /*float dist = length(interpolated.position.xy - float2(0.5));
    float4 out_color = interpolated.color;
    out_color.a = 1.0 - smoothstep(0.45, 0.5, dist);
    return out_color; //half4(out_color.r, out_color.g, out_color.b,1);*/
    
    return interpolated.color;
}

