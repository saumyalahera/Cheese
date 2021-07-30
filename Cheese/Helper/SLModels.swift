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
    
/*Patter rule check*/
    let patterCount = 3
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
    
/*Coins*/
    var coins = [[SLCircle?]]()// = Array(repeating: Array(repeating: nil, count: 7), count: 6)
    
    
    init(rows: Int, columns:Int) {
        for i in 0..<columns {
            self.topPositions[i] = 0
            self.currentCoinsColumnTopPositions.append(0)
        }
        self.coins = Array(repeating: Array(repeating: nil, count: Int(self.cols)), count: Int(self.rows))
    }
    
/*This method is used for AI. It will just return a ransdom number*/
    func makeAIPlay() -> Int?{
        guard let column = self.topPositions.randomElement()?.key else {
            return nil
        }
        return column
    }
    
/*This is used to check for winner*/
    func winnerCheck() {
     
    }
    
/*Check if horizontal check is valid or not*/
    func horizontalCheck(x: Int, y:Int, maxCol:Int) -> Bool{
        
        let minColumn = max(0, x-3)
        let maxColumn = min(maxCol,x+3)
        
        let iterations = (maxColumn - minColumn) - patterCount
        var ix = minColumn-1
        print("Min: \(minColumn), Max: \(maxColumn), Iterations: \(iterations)")
        for _ in 0..<iterations {
            ix+=1
            print("c")
            /*let c1 = self.coins[ix][y]?.name
            let c2 = self.coins[ix+1][y]?.name
            let c3 = self.coins[ix+2][y]?.name
            let c4 = self.coins[ix+3][y]?.name
            
            print([c1,c2,c3,c4])*/
            
            //print(ix)
            guard let c1 = self.coins[ix][y]?.name, let c2 = self.coins[ix+1][y]?.name, let c3 = self.coins[ix+2][y]?.name, let c4 = self.coins[ix+3][y]?.name else {
                //print([c1,c2,c3,c4])
                continue
            }
            
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
    
    func verticalCheck(x: Int, y:Int, maxRow:Int) -> Bool{
        
        let minRow = min(0, y+3)
        let maxRow = max(maxRow,y-3)
        
        let iterations = (maxRow - minRow) - patterCount
        var iy = minRow-1
        
        for _ in 0...iterations {
            
            iy-=1
            guard let c1 = self.coins[x][iy]?.name, let c2 = self.coins[x][iy-1]?.name, let c3 = self.coins[x][iy-2]?.name, let c4 = self.coins[x][iy-3]?.name else {
                continue
            }
            
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
}

