//
//  ViewController.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//
/*
 reset
 diagonal
 view controller
 2 players
 */

import UIKit

class ViewController: UIViewController {

//MARK: - Cursor and Column blocks Properties
    
    /*These help us build the columns because they work with touch methods to track the selected column number*/
    ///They are needed to calculate block size
    var userInterfaceContext = SLUserInterfaceContext()
    
    /*Cursor shows which column user is pointing to*/
    ///This is used when a user drags or clicks on rows
    var cursor:SLCursor?
    
    ///These are used for cursor and highlights
    var canvasBlocks = [SLShape?]()
    
    ///This is where the main rendering is done
    var canvas:SLCanvas!
    
    ///Canvas info will be used to render subviews
    var canvasInfo = SLCanvasInfo(centerX: 0, centerY: 0, width: 0, height: 0)
    
    ///GAME Context
    var gameContext:SLGameContext!// = SLGameContext(rows: 6, columns: 7,)
    
    ///Setup players
    var player1 = SLPlayer(name: "player", color: SLGameSetings.playerOneCoinColor, score: 0)
    var player2 = SLPlayer(name: "AI", color: SLGameSetings.playerTwoCoinColor, score: 0)
    
//MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Get command Queue and device because withput these objects, engine should not ignite
        guard let device = SLPocket.createDevice(), let queue = SLPocket.createCommandQueue(device: device) else {
            return
        }
        SLTools.setupMetalComponents(device: device, queue: queue)
        
   //Setup Canvas
        self.setupCanvas()
        
    //Setup Game
        self.setupGame()
    }
}

//MARK: - Game Logic
extension ViewController {
    func setupGame() {
    
        self.gameContext = SLGameContext(columns: 7, rows: 6, gameType: .TwoPlayer, firstPlayer: true, playerOne: player1,playerTwo: player2)
        
    //Create canvas blocks, they are used to highlight columns and guides player to drop coins
        self.createCanvasBlocks()
            
    //Create a grid
        let x = self.userInterfaceContext.outerPadding
        var y = (self.canvasInfo.centerY)+(self.userInterfaceContext.columnHeight/2)
            
    //Add All the coins holder
        self.setupCoins(x: x, y: y)
            
    //Create a cursor that be used to guide which column the user has pressed
        y = (self.canvasInfo.centerY)-(self.userInterfaceContext.columnHeight/2)
        self.setupCursor(x: x, y: y)
        
        //self.resetGame()
    }
    
    func resetGame(text: String) {
        self.gameContext.resetGame(columns: 7, rows: 6, gameType: .TwoPlayer, firstPlayer: true, playerOne: player1, playerTwo: player2)
        print("current player: \(self.gameContext.currentPlayer.name) and color: \(self.gameContext.currentPlayer.color)")
    }
}

//MARK: - Coins Setup and Other Views setup
extension ViewController {
    
/*Canvas where all the objects are rendered*/
    func setupCanvas() {
        
        canvas = SLCanvas(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        canvas.color = UIColor.white
        self.view.addSubview(canvas)
        SLPocket.addConstraints(leading: 0, trailing: 0, top: 0, bottom: 0, view: canvas)
        
    //Update canvas information
        self.canvasInfo = SLCanvasInfo(centerX: Float(self.view.center.x), centerY: Float(self.view.center.y), width: Float(self.view.frame.width), height: Float(self.view.frame.height))
    }
    
    func setupCoins(x: Float, y:Float) {
        var x = x
        var y = y
        for row in 0..<Int(self.gameContext.rows) {
            
            x=self.userInterfaceContext.outerPadding
            for col in 0..<Int(self.gameContext.cols) {
                
                let coin = SLCircle(x: x+(self.userInterfaceContext.blockDimension/2), y: y-(self.userInterfaceContext.blockDimension/2), radius: 0.08)
                coin.color = SLGameSetings.defaultCoinColor
                canvas.addNode(shape: coin)
                x+=(self.userInterfaceContext.innerPadding+self.userInterfaceContext.blockDimension)
                self.gameContext.coins[col][row] = coin
                //print("\(col),\(row)")
            }
            y-=(self.userInterfaceContext.innerPadding+self.userInterfaceContext.blockDimension)
        }
    }
    
    func setupCursor(x: Float, y:Float) {
        self.cursor = SLCursor(x: self.canvasInfo.centerX, y: y-15, radius: 20)
        cursor!.color = .white
        canvas.addNode(shape: cursor!)
    }
}

//MARK: - Canvas Column Blocks - WILL FINISH IT SOON
/**They are used to create highlight effect. NOT COMPLETE**/
extension ViewController {
    
    func createCanvasBlocks() {
        //self.screenWidth = Float(self.view.frame.width)
    //Calculate block width
        self.userInterfaceContext.columnWidth = self.canvasInfo.width - (2*self.userInterfaceContext.outerPadding)
    //Get block width
        self.userInterfaceContext.blockDimension = self.userInterfaceContext.columnWidth - ((self.gameContext.cols-1)*self.userInterfaceContext.innerPadding)
        self.userInterfaceContext.blockDimension/=self.gameContext.cols
    //Get block height
        self.userInterfaceContext.columnHeight = (self.userInterfaceContext.blockDimension*self.gameContext.rows) + ((self.gameContext.rows-1)*self.userInterfaceContext.innerPadding)
    //Get column width
        self.userInterfaceContext.columnWidth/=self.gameContext.cols
    //Coordinates
        var x = self.userInterfaceContext.outerPadding
        let y = (self.canvasInfo.centerY)-(self.userInterfaceContext.columnHeight/2)
    //Setup blocks
        for _ in 0..<Int(self.gameContext.cols) {
            let s1 = SLSquare(x: x, y: y, width: self.userInterfaceContext.columnWidth, height: self.userInterfaceContext.columnHeight)
            s1.color = SLGameSetings.columnHighlightColor
            canvas.addNode(shape: s1)
            self.gameContext.columnBlocksCenterPositions.append(x+(self.userInterfaceContext.columnWidth/2))
            self.canvasBlocks.append(s1)
            x+=self.userInterfaceContext.columnWidth
        }
    }
}


//MARK: - Cursor Extension
/** This extension is used to keep track of cursor and it */
extension ViewController {
    
/**This function returns **/
    func getCursorCenterPositionCounter(x: Float, y:Float) -> Int? {
        
    //To check if the player is dragging in the zone
        let halfHeight = self.userInterfaceContext.columnHeight/2
        if(y <= (self.canvasInfo.centerY + halfHeight) && y >= (self.canvasInfo.centerY - halfHeight)) {
            
            let counter = Int(x/self.userInterfaceContext.columnWidth)
            
            guard counter < Int(self.gameContext.cols) else{
                return nil
            }
            return counter
        }
        return nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cursor = self.cursor else {
            return
        }
        
        guard let location = touches.first?.location(in: self.view) else {
            return
        }

        guard let counter = self.getCursorCenterPositionCounter(x: Float(location.x), y: Float(location.y)) else {
            return
        }
        
        cursor.color = SLGameSetings.cursorHighlightColor
        cursor.x = self.gameContext.columnBlocksCenterPositions[counter] //shape.x+(self.columnWidth/2)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cursor = self.cursor else {
            return
        }
        cursor.color = SLGameSetings.cursorColor
        
        guard let location = touches.first?.location(in: self.view) else {
            return
        }

        guard let column = self.getCursorCenterPositionCounter(x: Float(location.x), y: Float(location.y)) else {
            return
        }
        
    //Get row and column
        //let row = self.gameContext.currentCoinsColumnTopPositions[column]
        
        guard let turn = self.updatePlay(column: column, player: self.gameContext.currentPlayer) else {
            return
        }
        
        self.gameContext.playerOneTurn.toggle()
        
        self.gameContext.currentPlayer = self.gameContext.playerTwo
        
        if self.gameContext.playerOneTurn {
            self.gameContext.currentPlayer = self.gameContext.playerOne
        }
    
    }
    
    
    @discardableResult func updatePlay(column:Int, player:SLPlayer) -> Bool?{
        
        //self.gameContext.playerOneTurn = false
        
        let rowK = Int(self.gameContext.rows)
        let col = column
        let row = self.gameContext.currentCoinsColumnTopPositions[col]
    //
        if(row >= rowK) {
            return nil
        }
        
    //Get coin of that index, change color and increment the index so that other elements can be placed
        guard let coin = self.gameContext.coins[col][row] else {
            return nil
        }
        
        coin.color = player.color
        coin.name = player.name
        self.gameContext.currentCoinsColumnTopPositions[col]+=1
        self.gameContext.coinsCounter+=1
        self.gameContext.topPositions[col] = row
        
        if(row == (rowK-1)) {
            //Remove the key
            self.gameContext.currentCoinsColumnTopPositions[col] = rowK
            self.gameContext.topPositions[col] = nil
        }
        
        //self.gameContext.playerOneTurn = true
        
    //Check if the USER won or not
        if self.gameContext.winnerCheck(x: column, y: row, player: player) {
            
            var message = "\(player.name) Won!!!"
            if(self.gameContext.coinsCounter == 30) {
                message = "It is a draw"
            }
            
            //Display the poster
            //SHOW NEW GAME VIEW
            //self.resetGame()
            
            
            
            //Show view that shows the display
            //show the message sir
            
            //self.gameContext.resetPlay = false
            return nil
        }
        
        return true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cursor = self.cursor else {
            return
        }
        
        guard let location = touches.first?.location(in: self.view) else {
            return
        }

        guard let counter = self.getCursorCenterPositionCounter(x: Float(location.x), y: Float(location.y)) else {
            return
        }
        
        cursor.color = SLGameSetings.cursorHighlightColor
        cursor.x = self.gameContext.columnBlocksCenterPositions[counter]
    }
}

