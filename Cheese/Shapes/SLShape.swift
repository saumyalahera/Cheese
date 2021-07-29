//
//  SLShape.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import Foundation
import UIKit
import MetalKit

class SLShape: SLNode {
   
//MARK: - Properties
    /*It is super important because when you make changes to any of the x,y,width or height values, it should ne normalised and for that you need the frame size. Canvas that subviews the square object is the super object and we need that frame*/
    ///This stores information about the screen size
    var superViewFrame:CGRect?
    
    ///It stores vertices values
    var vertices:[simd_float2]!
    
    ///This will hold important information about the shape.
    var vertexBuffer:MTLBuffer!
    
    ///This is the default color
    var shapeColorConstant = SLShapeColorConstant(color: simd_float4(1,0,0,1))
    
    ///Can change color with a simple UIColor instance
    var color:UIColor? {
        didSet {
            guard let color = SLPocket.colorToSIMDComponents(color: color) else {
                return
            }
            self.shapeColorConstant.color = color
        }
    }
    
    ///It will be used to project the object by changing pixel coordinates to NDC 
    var uniforms: SLUniforms?
    
//MARK: - For Subclass methods
    /*This is required for initalising subclasses, when you add an object on a paper object, you should init buffers and vertices.*/
    func initialiseBuffers(frame: CGRect){
        guard let vertices = self.vertices else {
            return
        }
        //This is the main structure
        self.vertexBuffer = SLTools.device.makeBuffer(bytes: vertices, length: MemoryLayout<simd_float2>.stride*vertices.count, options: [])
    }
    
//MARK: - Shape Buffers
    func updateBuffers() {
        
        //Check the buffers and vertices are initialised
        guard  let vertexBuffer = self.vertexBuffer, let vertices = self.vertices else {
            return
        }
        
        //Update buffer
        vertexBuffer.contents().copyMemory(from: vertices, byteCount: vertices.count * MemoryLayout<simd_float2>.stride)
    }
    
//MARK: - Shape Render
    func render(renderCommandEncoder:MTLRenderCommandEncoder) {
        
        renderCommandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        //check if color is set then the renderpipeline changes
        renderCommandEncoder.setRenderPipelineState(SLTools.renderPipelineState)
        
        //Add a render command encoder
        renderCommandEncoder.setVertexBytes(&self.shapeColorConstant, length: MemoryLayout<SLShapeColorConstant>.stride, index: 1)
        
        //Render the shape
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertices.count)
    }
}


