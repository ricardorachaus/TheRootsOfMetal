//
//  Shaders.metal
//  MetalExample
//
//  Created by Ricardo Rachaus on 10/11/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 default_vertex(constant float3 *vertices [[ buffer(0) ]],
                             uint vertexID [[ vertex_id ]]) {
    return float4(vertices[vertexID], 1);
}

fragment half4 default_fragment() {
    return half(1);
}
