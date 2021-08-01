//
//  SLModels.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import simd
import UIKit

/**It is used to render color on shapes by passing vertex bytes**/
struct SLShapeColorConstant {
    var color:simd_float4
}

/**It is used to make orthographic projection. IT IS NOT IN USE RIGHT NOW*/
struct SLUniforms {
    var orthographicModelMatrix:simd_float4x4
}

/**It holds information about the canvas, it become easy to compute frames for UI elements*/
struct SLCanvasInfo {
    var centerX:Float
    var centerY:Float
    var width:Float
    var height:Float
}

public enum SLPlayerType {
    case Player
    case CPU
}

public enum SLGameType {
    case SinglePlayer
    case TwoPlayer
}

public enum SLDiagonalDirection {
    case Right
    case Left
    case Up
    case Down
}

/**This is the main logic where you only calculate horizontal, vertical and diagonal count**/
class SLPlayer {
    var name: String!
    var color:UIColor!
    var score:Int!
    
    init(name: String, color:UIColor, score: Int) {
        self.name = name
        self.color = color
        self.score = score
    }
}

class SLUserInterfaceContext {
    
    var outerPadding:Float = 5
    var innerPadding:Float = 3
    var blockDimension:Float = 0
    
/*This is used for animations, when a player taps, drags columns, they should animate.*/
    var columnWidth:Float = 0
    var columnHeight:Float = 0
    
}

