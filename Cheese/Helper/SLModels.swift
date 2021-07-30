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
        self.coins = Array(repeating: Array(repeating: nil, count: Int(self.rows)), count: Int(self.cols))
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
     
        let maxRow = Int(self.rows)-1
        let maxCol = Int(self.cols)-1
        
    }
    
/*Check if horizontal check is valid or not*/
    func horizontalCheck(x: Int, y:Int, maxCol:Int) -> Bool{
    
    //Get Max and Min so that you decide the range you want to check in
        let minColumn = max(0, x-patterCount)
        let maxColumn = min(maxCol,x+patterCount)
        
    //Also get the iteration number because you dont want to go through all the elements in the range
        var iterations = (maxColumn - minColumn) - patterCount
        iterations = max(0, iterations-1)
    
    //This is to keep track of index
        var ix = minColumn-1
        
    //Iterate and check
        for _ in 0...iterations {
            ix+=1
            guard let c1 = self.coins[ix][y]?.name, let c2 = self.coins[ix+1][y]?.name, let c3 = self.coins[ix+2][y]?.name, let c4 = self.coins[ix+3][y]?.name else {
                continue
            }
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
    
/*This is to check if it is vertical point or not*/
    func verticalCheck(x: Int, y:Int, maxRow:Int) -> Bool{
        
    //Get Max and Min so that you decide the range you want to check in
        let minRow = max(0, y-patterCount)
        let maxRow = min(maxRow,y+patterCount)
        
    //Also get the iteration number because you dont want to go through all the elements in the range
        var iterations = (maxRow - minRow) - patterCount
        iterations = max(0, iterations-1)
        
    //This is to keep track of index
        var iy = minRow-1
       
    //Iterate and check
        for _ in 0...iterations {
            iy+=1
            guard let c1 = self.coins[x][iy]?.name, let c2 = self.coins[x][iy+1]?.name, let c3 = self.coins[x][iy+2]?.name, let c4 = self.coins[x][iy+3]?.name else {
                continue
            }
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
    
/*Diagonal Check*/
    func diagonalCheck(x: Int, y:Int) -> Bool {
        
    //Get two points
        let p1 = self.getMinCoin(X: x, Y: y)
        let p2 = self.getMaxCoin(X: x, Y: y)
        
    //Calculates number of passes needed
        var iterations = (p2.x - p1.x) - patterCount
        iterations = max(0, iterations-1)
        
    //Index tracker
        var ix = p1.x-1
        var iy = p1.y-1
        
    //Iterate
        for _ in 0...iterations {
            ix+=1
            iy+=1
            guard let c1 = self.coins[ix][iy]?.name, let c2 = self.coins[ix+1][iy+1]?.name, let c3 = self.coins[ix+2][iy+2]?.name, let c4 = self.coins[ix+3][iy+3]?.name else {
                continue
            }
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
/*This will return the first/min diagonal coin*/
    func getMinCoin(X: Int, Y:Int) -> (x:Int, y:Int){
        
        var x = X - patterCount
        var y = Y - patterCount
        
        var k = min(x,y)
        
        k = (k < 0) ? abs(k) : 0
        
        x = k + x
        y = k + y
        
        return (x,y)
    }
    
/*This will return the last/max diagonal coin*/
    func getMaxCoin(X: Int, Y:Int) -> (x:Int, y:Int){
        
        var x = X + patterCount
        var y = Y + patterCount
        
        var k = max(x,y)
        
        k = (k > Int(cols-1)) ? Int(cols-1) - k : 0
        
        x = k + x
        y = k + y
        
        return (x,y)
        
    }
    
}

