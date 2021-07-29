//
//  SLCursor.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import UIKit
import MetalKit

class SLCursor:SLShape {
    
    //MARK: - Properties
    ///Vertices needed to render a triangle, also assuming that it is a 2D shape so z will be 0 by default
    var x:Float = 0 {
        didSet {
            self.processCoordinates()
        }
    }
    
    var y:Float = 0 {
        didSet {
            self.processCoordinates()
        }
    }
    
    var radius:Float = 0 {
        didSet {
            self.processCoordinates()
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
    
    //MARK: - Init Methods
    /**Process vertices of a triangle. It calculates normalised coordinates and store them in a buffer used for vertex buffer
        - Parameters:
            - frame: You need this for normalising coordinates*/
    override func initialiseBuffers(frame: CGRect) {
        
        //Init superframe
        self.superViewFrame = frame
        
    //process Coordinates
        self.processCoordinates()
        
        //Init vertex Buffer
        self.vertexBuffer = SLTools.device.makeBuffer(bytes: self.vertices, length: MemoryLayout<simd_float2>.size*self.vertices.count, options: [])
        
    }
    
    private func processCoordinates() {
        
        guard let frame = self.superViewFrame else {
            return
        }

        let r2 = radius/2
        let cx = x
        let cy = y+(r2)
        let v1 = simd_float2(x: SLPocket.normaliseX(x: cx, frame: frame), y: SLPocket.normaliseY(y: cy, frame: frame))
        
        let aby = cy-radius
        let v2 = simd_float2(x: SLPocket.normaliseX(x: cx-r2, frame: frame), y: SLPocket.normaliseY(y: aby, frame: frame))
        let v3 = simd_float2(x: SLPocket.normaliseX(x: cx+r2, frame: frame), y: SLPocket.normaliseY(y: aby, frame: frame))
        
        self.vertices = [v1,v2,v3]
        
        //Update buffers
        self.updateBuffers()
        
    }
}

