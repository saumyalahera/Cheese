//
//  ViewController.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import UIKit

class ViewController: UIViewController {

//MARK: - Cursor and Column blocks Properties
    
    /*These help us build the columns because they work with touch methods to track the selected column number*/
    ///They are needed to calculate block size
    var outerPadding:Float = 5
    var innerPadding:Float = 3
    //var rows:Float = 6
    //var cols:Float = 7
    var blockDimension:Float = 0
    
    /*This is used for animations, when a player taps, drags columns, they should animate.*/
    var columnWidth:Float = 0
    var columnHeight:Float = 0
    
    /*Cursor shows which column user is pointing to*/
    ///This is used when a user drags or clicks on rows
    var cursor:SLCursor?
    
    ///Store center positions of the columns
    var columnBlocksCenterPositions = [Float]()
    
    ///These are used for cursor and highlights
    var canvasBlocks = [SLShape?]()
    
    ///This is where the main rendering is done
    var canvas:SLCanvas!
    
    ///Canvas info will be used to render subviews
    var canvasInfo = SLCanvasInfo(centerX: 0, centerY: 0, width: 0, height: 0)
    
    ///Coin and coordinates
    var coins:[[SLCircle?]] = Array(repeating: Array(repeating: nil, count: 7), count: 6)
    
    ///GAME Context
    var gameContext = SLGameContext(rows: 6, columns: 7)
    
    
    
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
        
    //Create canvas blocks, they are used to highlight columns and guides player to drop coins
        self.createCanvasBlocks()
        
    //Create a grid
        let x = outerPadding
        var y = (self.canvasInfo.centerY)+(columnHeight/2)
        
    //Add All the coins holder
        self.setupCoins(x: x, y: y)
        
    //Create a cursor that be used to guide which column the user has pressed
        y = (self.canvasInfo.centerY)-(columnHeight/2)
        self.setupCursor(x: x, y: y)
    }
}

//MARK: - Game Logic
extension ViewController {
    
    func setupPlayers() {
        
        
        
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
        for i in 0..<Int(self.gameContext.rows) {
            
            x=outerPadding 
            for j in 0..<Int(self.gameContext.cols) {
                
                let coin = SLCircle(x: x+(blockDimension/2), y: y-(blockDimension/2), radius: 0.08)
                coin.color = SLGameSetings.defaultCoinColor
                canvas.addNode(shape: coin)
                x+=(innerPadding+blockDimension)
                self.coins[i][j] = coin
            }
            y-=(innerPadding+blockDimension)
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
        columnWidth = self.canvasInfo.width - (2*outerPadding)
    //Get block width
        blockDimension = columnWidth - ((self.gameContext.cols-1)*innerPadding)
        blockDimension/=self.gameContext.cols
    //Get block height
        columnHeight = (blockDimension*self.gameContext.rows) + ((self.gameContext.rows-1)*innerPadding)
    //Get column width
        columnWidth/=self.gameContext.cols
    //Coordinates
        var x = outerPadding
        let y = (self.canvasInfo.centerY)-(columnHeight/2)
    //Setup blocks
        for _ in 0..<Int(self.gameContext.cols) {
            let s1 = SLSquare(x: x, y: y, width: columnWidth, height: columnHeight)
            s1.color = SLGameSetings.columnHighlightColor
            canvas.addNode(shape: s1)
            self.columnBlocksCenterPositions.append(x+(columnWidth/2))
            self.canvasBlocks.append(s1)
            x+=columnWidth
        }
    }
}


//MARK: - Cursor Extension
/** This extension is used to keep track of cursor and it */
extension ViewController {
    
/**This function returns **/
    func getCursorCenterPositionCounter(x: Float, y:Float) -> Int? {
        
    //To check if the player is dragging in the zone
        let halfHeight = self.columnHeight/2
        if(y <= (self.canvasInfo.centerY + halfHeight) && y >= (self.canvasInfo.centerY - halfHeight)) {
            
            let counter = Int(x/self.columnWidth)
            
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
        cursor.x = self.columnBlocksCenterPositions[counter] //shape.x+(self.columnWidth/2)
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
        
        guard let turn = self.updatePlay(column: column, playerCoinColor: SLGameSetings.playerOneCoinColor) else {
            return
        }
        
        guard let column = self.gameContext.makeAIPlay() else {
            return
        }
        
        self.updatePlay(column: column, playerCoinColor: SLGameSetings.playerTwoCoinColor)
        
        
        //CPU TURN
        //self.gameContext.
        
        
    //Check if the player has won or not
        
    //Change cursor if there is another player
        
    //CPU Turn
    
    }
    
    func updatePlay(column:Int, playerCoinColor:UIColor) -> Bool?{
        
        let rowK = Int(self.gameContext.rows)
        let col = column
        let row = self.gameContext.currentCoinsColumnTopPositions[col]
        
        if(row >= rowK) {
            return nil
        }
        
    //Get coin of that index, change color and increment the index so that other elements can be placed
        guard let coin = self.coins[row][col] else {
            return nil
        }
        
        coin.color = playerCoinColor
        self.gameContext.currentCoinsColumnTopPositions[col]+=1
        self.gameContext.topPositions[col] = row
        
        
        if(row == (rowK-1)) {
            //Remove the key
            self.gameContext.currentCoinsColumnTopPositions[col] = rowK
            self.gameContext.topPositions[col] = nil
        }
        
    //Check if the USER won or not
        
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
        cursor.x = self.columnBlocksCenterPositions[counter]
    }
}

