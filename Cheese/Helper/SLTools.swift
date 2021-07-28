//
//  SLTools.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import Foundation
import MetalKit

/**This is a singleton class that has important non-transient objects for optimisation*/
public class SLTools: NSObject {
    
    //MARK: - Create a shared device object
    static let shared = SLTools()

    ///It is needed to create a metal device that will be used throughout the application
    public static var device:MTLDevice!
    
    ///Command Queue holds command buffers for rendering
    public static var queue:MTLCommandQueue!
    
    ///Render Command Pipeline
    public static var renderPipelineState:MTLRenderPipelineState!
    
    
    private override init() {}

//MARK: - It only creates device when it is called
    public static func setupMetalComponents(device: MTLDevice, queue: MTLCommandQueue) {
        /*Create device and queues*/
        self.device = device
        self.queue = queue
        /*I am doing this because for this engine, there will only be one pipeline state*/
        makeRenderPipeline()
    }

    
    public static func makeRenderPipeline() {
        guard let renderPipelineDescriptor = SLPocket.createRenderPipelineDescriptor(device: device, vertexFunctionName: "vertexShader", fragmentFunctionName: "fragmentShader") else {
            print("Cannot init render pipeline")
            return
        }
        renderPipelineState = SLPocket.createRenderPipeline(device: device!, renderPipelineDescriptor: renderPipelineDescriptor)
    }
}
