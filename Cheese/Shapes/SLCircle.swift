//
//  SLCircle.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/29/21.
//

import Foundation
import UIKit
import MetalKit

class SLCircle:SLShape {
    
    /*  1. Create a circle
        2. Init x,r and radius
        3. Only call process coordinates when it is placed on a paper view
        4. When placed on a paper, compute buffers
            1. initialBuffers -> process coordinates
        */
    
    //MARK: - Properties
    ///Vertices needed to render a triangle, also assuming that it is a 2D shape so z will be 0 by default
    var x:Float = 0 {
        didSet {
            //self.updateCoordinate(index: 0, newValue: Pocket.normaliseX(x: x1, frame: self.superViewFrame!))
        }
    }
    
    var y:Float = 0 {
        didSet {
            //self.updateCoordinate(index: 1, newValue: Pocket.normaliseY(y: y1, frame: self.superViewFrame!))
        }
    }
    
    var radius:Float = 0{
        didSet {
            //self.updateCoordinate(index: 1, newValue: Pocket.normaliseY(y: y1, frame: self.superViewFrame!))
        }
    }
    
   
    //MARK: - Init Methods
    /**Init with triangle coordinates with triangle color.
        - Parameters:
            - Coordinates: These form a triangle
            - color: triangle color*/
    init(x:Float, y:Float, radius:Float, color: UIColor = .white) {
        super.init()
        self.x = x
        self.y = y
        self.radius = radius
        self.color = color
    }
    
    //MARK: - Personal Methods
    func processCoordinates() {
        //This function will process all the coordinates
        self.circle(x: self.x, y: self.y, radius: self.radius)
    }
    

    //MARK: - Init Methods
    /**Process vertices of a triangle. It calculates normalised coordinates and store them in a buffer used for vertex buffer
        - Parameters:
            - frame: You need this for normalising coordinates*/
    override func initialiseBuffers(frame: CGRect) {
        
        //Init superframe
        self.superViewFrame = frame
        
        //Compute vertices
        self.processCoordinates()
    
        //This is the main structure
        self.vertexBuffer = SLTools.device.makeBuffer(bytes: self.vertices, length: MemoryLayout<simd_float2>.stride*self.vertices.count, options: [])
        
    }
    
    func circle(x: Float, y: Float, radius: Float) {
        
        //Need to change this
        /*func rads(forDegree d: Float)->Float{
            return (Float.pi*d)/180
        }*/
        
        let aspectRatio = simd_float1((self.superViewFrame?.size.width)!/(self.superViewFrame?.size.height)!)
        
        self.vertices = [simd_float2]()
        
        let nx = SLPocket.normaliseX(x: x, frame: self.superViewFrame!)
        let ny = SLPocket.normaliseY(y: y, frame: self.superViewFrame!)
        //let rx = SLPocket.normaliseX(x: radius, frame: self.superViewFrame!)
        //let ry = SLPocket.normaliseY(y: radius, frame: self.superViewFrame!)
        
        let origin = simd_float2(nx, ny)
        
        for i in 0...720 {
            
            var position : simd_float2 = [(cos(SLPocket.degreesToRadians(Float(Float(i))))*radius)+origin.x,(sin(SLPocket.degreesToRadians(Float(Float(i))))*radius)+origin.y]
            
            //position  = [(cos(SLPocket.degreesToRadians(Float(Float(i))))*rx)+origin.x,(sin(SLPocket.degreesToRadians(Float(Float(i))))*ry)+origin.y]
            
            var x_x = cos(SLPocket.degreesToRadians(Float(Float(i))))
            var y_y = sin(SLPocket.degreesToRadians(Float(Float(i)))) * aspectRatio
            
            x_x = (x_x * radius)+origin.x
            y_y = (y_y * radius)+origin.y
            
            
            position.x = x_x
            position.y = y_y
            
            //position.y *= aspectRatio
            self.vertices.append(position)
            
            if (i+1)%2 == 0 {
                self.vertices.append(origin)
            }
        }
        
    //Update buffers
        self.updateBuffers()
    
    }
    
    override func render(renderCommandEncoder:MTLRenderCommandEncoder) {
        
        renderCommandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
        
        //check if color is set then the renderpipeline changes
        renderCommandEncoder.setRenderPipelineState(SLTools.renderPipelineState!)
        
        //Add a render command encoder
        renderCommandEncoder.setVertexBytes(&self.shapeColorConstant, length: MemoryLayout<SLShapeColorConstant>.stride, index: 1)
        
        //renderCommandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: self.circleVertices.count)
        
        renderCommandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: self.vertices.count)
    }

}
