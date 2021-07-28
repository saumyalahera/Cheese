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
    
    ///Render Pipeline State with index shaders
    public static var renderPipelineStateTextured:MTLRenderPipelineState!
    
    private override init() {}

    //MARK: - It only creates device when it is called
    public static func makeDevice(metal:MTLDevice) {
        device = metal
        queue = device.makeCommandQueue()
    }
    
    public static func makeRenderPipeline() {
        
        //let renderPipelineDescriptor = Pocket.createRenderPipelineDescriptor(device: device, vertexFunctionName: "colored_vertex", fragmentFunctionName: "colored_fragment")
        //vertexShader
        let renderPipelineDescriptor = SLPocket.createRenderPipelineDescriptor(device: device, vertexFunctionName: "vertexShader", fragmentFunctionName: "fragmentShader")
        renderPipelineState = SLPocket.createRenderPipeline(device: device!, renderPipelineDescriptor: renderPipelineDescriptor)
    }
    
//MARK: - Experiments
     
    
}
