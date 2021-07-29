//
//  SLCanvas.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//
import UIKit
import MetalKit

//var frameTimer:Float = 0

/*Optimisations:
 1. Need to make sure that only used pipelines are instantiated
 2. */

//This is used to set color



class SLCanvas: MTKView {
    
    //It will all th ebjects for rendering
    var shapes = [SLShape]()
    
//MARK: - Color property
    ///Color KVO is used to clear color
    var color: UIColor? {
        didSet {
            guard let color = SLPocket.colorToMTLClearColor(color: color) else {
                return
            }
            self.clearColor = color
        }
    }
    
//MARK: - Init Methods
    
    init(frame:CGRect) {
    
        //Init super
        super.init(frame: frame, device: SLTools.device)
    
        //Set clear color
        self.color = UIColor.white
        
        //Delegate
        self.delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SLCanvas: MTKViewDelegate {
    
//MARK: - Metal View Delegate Functions
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    
//Just use it for clearing color
    func draw(in view: MTKView) {
    
        guard let renderPassDescriptor = view.currentRenderPassDescriptor, let drawable = view.currentDrawable else {
            return
        }
        
        /*frameTimer += (1 / Float(view.preferredFramesPerSecond))/10
        print(frameTimer)*/
        
        //Command Buffer to process all the commands
        let commandBuffer = SLTools.queue.makeCommandBuffer()
        
        //Commands converter
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        //Render al lthe objects
        for shape in self.shapes {
            shape.render(renderCommandEncoder: commandEncoder!)
        }
        
        //Commit commands
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

extension SLCanvas {
    
    //MARK: - Add Shapes
    /**This function adds shapes to the canvas
        - Parameters:
            - shape: It is the shape that you want to render on the canvas*/
    func addNode(shape:SLShape) {
    
        //Check of the render pipeline is set or not, this is needed if there are multiple pipelines.
        /*if SLTools.renderPipelineState == nil {
            SLTools.makeRenderPipeline()
        }*/
        
        /*Reason to have this function is that you only init buffers when you add it to the canvas or paper*/
        shape.initialiseBuffers(frame: self.frame)
        
        
        /*This is where rendering starts*/
        self.shapes.append(shape)
    }
}

