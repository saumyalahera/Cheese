//
//  SLSquare.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/29/21.
//


import UIKit
import MetalKit

class SLSquare: SLShape {

      /*1. Create a Square
        2. Init x, y,width, height
        3. Only call process coordinates when it is placed on a paper view
        4. When placed on a paper, compute buffers
            1. initialBuffers -> process coordinates*/
    
//MARK: - Properties
    var x: Float = 0 {
        didSet {
            self.processCoordinates()
        }
    }
    
    var y: Float = 0 {
        didSet {
            self.processCoordinates()
        }
    }
    
    var width: Float = 0 {
        didSet {
            self.processCoordinates()
        }
    }
    
    var height: Float = 0 {
        didSet {
            self.processCoordinates()
        }
    }
    
    ///Index buffer needed for optimisation
    var indexBuffer:MTLBuffer!

    ///Specify index
    var indices:[UInt16] = [0,1,2,2,3,0]
    

//MARK: - Init Methods
    
    /*---------- Init Methods ----------*/
    init(x: Float, y:Float, width:Float, height:Float) {
        super.init()
        
        //Init all the values for drawing a square
        self.x = x
        self.y = y
        self.height = height
        self.width = width
    }
    
//MARK: - Personal Methods
    private func processCoordinates() {
       
        //Check if the frame
        guard let frame = self.superViewFrame else {
            return
        }
        
        //Top Left (x1,y1)
        var x1 = (self.x < 0) ? 0 : self.x
        var y1 = (self.y < 0) ? 0 : self.y
        
        //Top Right (x2,y1)
        var x2:Float = (x+width > Float(frame.width)) ? width : x+width
        
        //Bottom Left (x1, y2)
        var y2:Float = (y+height > Float(frame.height)) ? height : y+height
        
        //Change points
        let xk = 1/Float(frame.width)
        let yk = 1/Float(frame.height)
        
        //Normalise x1 and y1
        x1 = ((2*x1)*xk)-1
        y1 = ((-2*y1)*yk)+1
         
        //Normalise x2 and y2
        x2 = ((2*x2)*xk)-1
        y2 = ((-2*y2)*yk)+1
        
        
        //This is when you want to use index buffer
        self.vertices = [simd_float2(x1,y1), //v1 tl
                        simd_float2(x2,y1), //v2 tr
                        simd_float2(x2,y2), //v3 br
                        simd_float2(x1,y2)] //v4 bl
        
        //Update buffers
        self.updateBuffers()
        
    }
    
    /*This method is called when paper view is adding this view as a subview. It will set superFrame var and it will have the frame of the paper view. We need superFrame because everytime user changes coordinate(s), this function calculates square shape and updates the buffer if buffers are initialised. First time, buffers are initialised with the new values.*/
    override func initialiseBuffers(frame: CGRect) {
        
    //This is required when there are some changes in the coordinates
        self.superViewFrame = frame
    //Process coordinates
        self.processCoordinates()
    //Init vertex Buffer
        self.vertexBuffer = SLTools.device.makeBuffer(bytes: self.vertices, length: MemoryLayout<simd_float2>.stride*self.vertices.count, options: [])
    //Init index buffer
        self.indexBuffer = SLTools.device.makeBuffer(bytes: self.indices, length: MemoryLayout<UInt16>.size*self.indices.count, options: [])
    //Init orthographic Matrix
        //self.uniforms = SLUniforms(SLPocket.orthographicModelMatrix: self.makeOrthographicMatrixc(left: 0, right: Float(superViewFrame!.width), bottom: Float(superViewFrame!.height), top: 0, near: -1, far: 1))
        
        
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
        renderCommandEncoder.setRenderPipelineState(SLTools.renderPipelineState)
        
        renderCommandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        //Add a render command encoder
        renderCommandEncoder.setVertexBytes(&self.shapeColorConstant, length: MemoryLayout<SLShapeColorConstant>.stride, index: 1)
        
        //renderCommandEncoder.setVertexBytes(&self.uniforms, length: MemoryLayout<SLUniforms>.stride, index: 2)
        
        //Render with indexed vertices
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer, indexBufferOffset: 0)
    }

}
