//
//  MetalView.swift
//  MetalExample
//
//  Created by Ricardo Rachaus on 10/11/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import MetalKit

final class MetalView: MTKView {
    
    let vertices: [SIMD3<Float>] = [
        SIMD3<Float>(0.0, 0.5, 0.0),
        SIMD3<Float>(-0.5, -0.5, 0.0),
        SIMD3<Float>(0.5, -0.5, 0.0),
    ]
    
    var vertexBuffer: MTLBuffer!
    var renderPipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        createRenderPipelineState()
    }
    
    func setup() {
        device = MTLCreateSystemDefaultDevice()
        clearColor = MTLClearColor(red: 0.1, green: 0.2, blue: 0.5, alpha: 1)
        vertexBuffer = device?.makeBuffer(bytes: vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, options: [])
        commandQueue = device?.makeCommandQueue()
    }
    
    func createRenderPipelineState() {
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "default_vertex")
        let fragmentFunction = library?.makeFunction(name: "default_fragment")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do {
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawable = currentDrawable, let renderPassDescriptor = currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
