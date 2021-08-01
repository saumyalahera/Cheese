//
//  SLGameContext.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/29/21.
//

import Foundation

class SLGameContext {
    
//MARK: - Properties
/*Create a move variable that keeps track if the move was complete or not*/
    var completedMove = false
/*Patter rule check*/
    let patternCount = 3
/*Turn- This decides who playe first*/
   var playerOneTurn = true
/*Columns and Rows*/
    var rows:Float = 6
    var cols:Float = 7
    
/*Create players used to keep track of current score and other settings*/
    var playerOne:SLPlayer!
    var playerTwo:SLPlayer!
/*This is useful for p1 vs p2 game*/
    var currentPlayer:SLPlayer!
    
/*Players can only 7*6 coins so check for it. CHECK AFTER USERS HAS FINISHED THE GAME*/
    var coinsCounter = 0
    
/*This will hold information about the currenct counter of the top space*/
    var currentCoinsColumnTopPositions = [Int]()

/*This is for AI*/
    var rowsPositions = [Int]()
    var columnsPositions = [Int]()

/*Dictionary to store top positions*/
    var topPositions = [Int:Int]()
    
/*Game type*/
    var gameType:SLGameType!
    
/*Coins*/
    var coins = [[SLCircle?]]()// = Array(repeating: Array(repeating: nil, count: 7), count: 6)
    
/*Check the center position of each and every block*/
    var columnBlocksCenterPositions = [Float]()
    
//MARK: - Init Method
    init(columns: Int, rows:Int, gameType: SLGameType, firstPlayer: Bool, playerOne: SLPlayer, playerTwo: SLPlayer) {
        self.setupGameEssentials(columns: columns, rows: rows, gameType: gameType, firstPlayer: firstPlayer, playerOne: playerOne, playerTwo: playerTwo)
        self.coins = Array(repeating: Array(repeating: nil, count: Int(self.rows)), count: Int(self.cols))
    }
//MARK: - Reset Logic
    func resetColumns(columns:Int) {
        self.topPositions.removeAll()
        self.currentCoinsColumnTopPositions.removeAll()
        for i in 0..<columns {
            self.topPositions[i] = 0
            self.currentCoinsColumnTopPositions.append(0)
        }
    }
    
    func resetCoins(columns: Int, rows: Int) {
        self.coinsCounter = 0
        for row in 0..<rows {
            for col in 0..<columns {
                guard let coin = self.coins[col][row] else {
                    continue
                }
                coin.color = SLGameSettings.defaultCoinColor
                coin.name = nil
            }
        }
    }
    
    func setupGameEssentials(columns: Int, rows:Int, gameType: SLGameType, firstPlayer: Bool, playerOne: SLPlayer, playerTwo: SLPlayer) {
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        self.playerOneTurn = firstPlayer
        self.gameType = gameType
        self.currentPlayer = self.playerOne
        SLGameSettings.cursorHighlightColor = self.playerOne.color
        if !firstPlayer {
            self.currentPlayer = self.playerTwo
            SLGameSettings.cursorHighlightColor = self.playerTwo.color
        }
        self.resetColumns(columns: columns)
    }
    
    func resetGame(columns: Int, rows:Int, gameType: SLGameType, firstPlayer: Bool, playerOne: SLPlayer, playerTwo: SLPlayer) {
        self.setupGameEssentials(columns: columns, rows: rows, gameType: gameType, firstPlayer: firstPlayer, playerOne: playerOne, playerTwo: playerTwo)
        self.resetCoins(columns: columns, rows: rows)
    }
    
//MARK: - CPU Play
/*This method is used for AI. It will just return a ransdom number*/
    func makeAIPlay() -> Int?{
        guard let column = self.topPositions.randomElement()?.key else {
            return nil
        }
        return column
    }
    
//MARK: - Winner Logic
/*This is used to check for winner*/
    func winnerCheck(x: Int, y:Int, player:SLPlayer) -> Bool{
     
        let maxRow = Int(self.rows)-1
        let maxCol = Int(self.cols)-1
        

        if self.horizontalCheck(x: x, y: y, maxCol: maxCol) || self.verticalCheck(x: x, y: y, maxRow: maxRow) || self.upDiagonalCheck(x: x, y: y) || self.downDiagonalCheck(x: x, y: y) {
            player.score+=1
            //print("\(player.name) won! Player One: \(playerOne.score), Player Two: \(playerTwo.score)")
            return true
        }
        
        if(self.coinsCounter >= Int(self.rows*self.cols)) {
            self.coinsCounter = 30
            return true
        }
        
        return false
    }
    
    
//MARK: - Directional Check
    
    func downDiagonalCheck(x: Int, y:Int) -> Bool {
        
        //Get two points
        let p1 = self.getDiagonalXYWithDirections(X: x, Y: y, xDirection: .Left, yDirection: .Up)
        let p2 = self.getDiagonalXYWithDirections(X: x, Y: y, xDirection: .Right, yDirection: .Down)
        
        var iterations = (p2.x - p1.x) - patternCount
        iterations+=2
        iterations = max(0, iterations-1)
        
        //Index tracker
        var ix = p1.x-1
        var iy = p1.y+1
                
        //Iterate
        for _ in 0..<iterations {
            ix+=1
            iy-=1
            guard let c1 = self.coins[ix][iy]?.name, let c2 = self.coins[ix+1][iy-1]?.name, let c3 = self.coins[ix+2][iy-2]?.name, let c4 = self.coins[ix+3][iy-3]?.name else {
                continue
            }
    
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
    
/*Diagonal Check*/
    func upDiagonalCheck(x: Int, y:Int) -> Bool {
            
    //Get the coordinates
        let p1 = self.getDiagonalXYWithDirections(X: x, Y: y, xDirection: .Left, yDirection: .Down)
        let p2 = self.getDiagonalXYWithDirections(X: x, Y: y, xDirection: .Right, yDirection: .Up)
        
    //Calculates number of passes needed
        var iterations = (p2.x - p1.x) - patternCount
        iterations+=2
        iterations = max(0, iterations-1)
            
    //Index tracker
        var ix = p1.x-1
        var iy = p1.y-1
            
    //Iterate
        for _ in 0..<iterations {
            ix+=1
            iy+=1
           
            guard let c1 = self.coins[ix][iy]?.name, let c2 = self.coins[ix+1][iy+1]?.name, let c3 = self.coins[ix+2][iy+2]?.name, let c4 = self.coins[ix+3][iy+3]?.name else {
                continue
             }
            print("I am here: \([c1,c2,c3,c4])")
            if Set([c1,c2,c3,c4]).count == 1 {
                return true
            }
        }
        return false
    }
    

/*Check if horizontal check is valid or not*/
    func horizontalCheck(x: Int, y:Int, maxCol:Int) -> Bool{
    
    //Get Max and Min so that you decide the range you want to check in
        let minColumn = max(0, x-patternCount)
        let maxColumn = min(maxCol,x+patternCount)
        
    //Also get the iteration number because you dont want to go through all the elements in the range
        var iterations = (maxColumn - minColumn) - patternCount
        iterations = max(0, iterations)
    
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
        let minRow = max(0, y-patternCount)
        let maxRow = min(maxRow,y+patternCount)
        
    //Also get the iteration number because you dont want to go through all the elements in the range
        var iterations = (maxRow - minRow) - patternCount
        iterations = max(0, iterations) //iterations-1
        
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
    
//MARK: - Diagonal Min and Max Finder
    
    func getDiagonalXYWithDirections(X: Int, Y:Int, xDirection: SLDiagonalDirection, yDirection: SLDiagonalDirection) -> (x:Int, y:Int) {
        
    //This is for the left direction
        var x = max(0,X-patternCount)
        x = X - x
        var xSign = -1
        
    //This is for the right direction
        if(xDirection == .Right) {
            x = min(X+patternCount,(Int(cols-1)))
            x = x - X
            xSign = 1
        }
        
    //This is for up direction
        var y = min(Y+patternCount,Int(rows-1))
        y = y - Y
        var ySign = 1
        
    //This is for down directions
        if( yDirection == .Down) {
            y = max((Y-patternCount),0)
            y = Y - y
            ySign = -1
        }
        
        let k = min(x,y)
        
        return (X + (k*xSign),Y + (k*ySign))
    }
    
}



