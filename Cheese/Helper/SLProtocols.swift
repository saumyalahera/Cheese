//
//  SLProtocols.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import Foundation
import MetalKit

protocol SLShapeDelegate {
    func shapeInitBuffers()
    func shapeUpdateBuffers()
    func shapeRender(_ encoder: MTLCommandEncoder)
}
