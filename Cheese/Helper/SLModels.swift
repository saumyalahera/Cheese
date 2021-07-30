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

enum SLPlayerType {
    case Player
    case CPU
}

public enum SLGameType {
    case SinglePlayer
    case TwoPlayer
}

/**This is the main logic where you only calculate horizontal, vertical and diagonal count**/
class SLPlayer {
    var name: String!
    var color:UIColor!
    var score:Int!
    var type:SLPlayerType!
    

}

class SLUserInterfaceContext {
    
    
}

class SLGameContext {
    
/*Turn*/
   var playerOneTurn = true
/*Columns and Rows*/
    var rows:Float = 6
    var cols:Float = 7
    
/*Create players used to keep track of current score and other settings*/
    var playerOne:SLPlayer!
    var playerTwo:SLPlayer!
    
/*Players can only 7*6 coins so check for it. CHECK AFTER USERS HAS FINISHED THE GAME*/
    var coinsCounter = 0
    
/*This will hold information about the currenct counter of the top space*/
    var currentCoinsColumnTopPositions = [Int]()

/*This is for AI*/
    var rowsPositions = [Int]()
    var columnsPositions = [Int]()

/*Dictionary to store top positions*/
    var topPositions = [Int:Int]()
    
    
    init(rows: Int, columns:Int) {
        for i in 0..<columns {
            self.topPositions[i] = 0
            self.currentCoinsColumnTopPositions.append(0)
        }
        //self.currentCoinsColumnTopPositions = Array(repeating: 0, count: columns)
        //self.rowsPositions = Array(repeating: 0, count: rows)
        //self.columnsPositions = Array(repeating: 0, count: columns)
    }
    
    /*This method is used for AI. It will just return a ransdom number*/
    func makeAIPlay() -> Int?{
        //ALWAYS MAKE SURE THAT IT IS A VALID
        guard let column = self.topPositions.randomElement()?.key else {
            return nil
        }
        return column
    }
}

