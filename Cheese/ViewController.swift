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
    
    ///Create UI elements
    var gameMenu:UIView!
    var player2Button:UIButton!
    var player1Button:UIButton!
    var menuLabel:UILabel!
    
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
    var gameContext:SLGameContext!
    
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
        
        //Setup other views
        self.setupOtherViews()
    }
}

//MARK: - Game Logic
/*This extension is used for game logic. It is to setup game, game context and other stuff*/
extension ViewController {
    
/*This functio is used to setup game
    1. Get the context
    2. Setup canvas
    3. Setup cursor and other UI elements*/
    func setupGame() {
        //Get the game menu on
        self.setupGameMenu()
        
        self.gameContext = SLGameContext(columns: SLGameSetings.columns, rows: SLGameSetings.rows, gameType: SLGameSetings.gameType, firstPlayer: true, playerOne: player1,playerTwo: player2)
        
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
    
/*This function is to reset game
    1. Set columns rows
    2. Set game type
    3. Change player order*/
    func resetGame(text: String) {
        self.gameContext.resetGame(columns: SLGameSetings.columns, rows: SLGameSetings.rows, gameType: SLGameSetings.gameType, firstPlayer: true, playerOne: player1, playerTwo: player2)
    }
}

//MARK: - Game UI Elements
/*This extension is used to define game ui elements. Elements like canvas */
extension ViewController {
    
/*Create a menu view that will display game types and you can choose which game to play*/
    
    func setupGameMenu() {
        self.gameMenu = SLPocket.getView(color: .white)
        self.view.addSubview(self.gameMenu)
        SLPocket.addConstraints(leading: 0, trailing: 0, top: 0, bottom: 0, view: self.gameMenu)
        
        let holder = SLPocket.getView(color: .white)
        self.gameMenu.addSubview(holder)
        SLPocket.addConstraints(leading: 0, trailing: 0, height: 400, view: holder)
        
        let cancelButton = SLPocket.getButton(title: "CANCEL", background: SLGameSetings.lightPurpleColor, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        cancelButton.addTarget(self, action: #selector(cancelMenuTapped), for: .touchDown)
        holder.addSubview(cancelButton)
        SLPocket.addConstraints(leading: 0, trailing: 0, bottom: 0, height: 100, view: cancelButton)
        
        let twoPlayersButton = SLPocket.getButton(title: "2 PLAYER", background: SLGameSetings.lightGreenColor, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        twoPlayersButton.addTarget(self, action: #selector(twoPlayersTapped), for: .touchDown)
        holder.addSubview(twoPlayersButton)
        SLPocket.addConstraints(leading: 0, trailing: 0, bottom: -100, height: 100, view: twoPlayersButton)
        
        let onePlayersButton = SLPocket.getButton(title: "1 PLAYER", background: SLGameSetings.lightPurpleColor, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        onePlayersButton.addTarget(self, action: #selector(onePlayersTapped), for: .touchDown)
        holder.addSubview(onePlayersButton)
        SLPocket.addConstraints(leading: 0, trailing: 0, bottom: -200, height: 100, view: onePlayersButton)
        
        self.menuLabel = SLPocket.getLabel(textColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        holder.addSubview(self.menuLabel)
        self.menuLabel.text = "Saumya Lahera"
        SLPocket.addConstraints(leading: 0, trailing: 0, top: 0, bottom: -300, view: self.menuLabel)
        
    }
    
/*This function is used to setup Canvas
    1. Get the context
    2. Setup canvas
    3. Setup cursor and other UI elements*/
    func setupCanvas() {
        
        canvas = SLCanvas(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        canvas.color = UIColor.white
        self.view.addSubview(canvas)
        SLPocket.addConstraints(leading: 0, trailing: 0, top: 0, bottom: 0, view: canvas)
        
        //Update canvas information
        self.canvasInfo = SLCanvasInfo(centerX: Float(self.view.center.x), centerY: Float(self.view.center.y), width: Float(self.view.frame.width), height: Float(self.view.frame.height))
    }
    
/*This function is used to setup Coins
    1. Setup Coins
    2. Setup canvas
    3. Setup cursor and other UI elements*/
    func setupCoins(x: Float, y:Float) {
        var x = x
        var y = y
        for row in 0..<SLGameSetings.rows {
            
            x=self.userInterfaceContext.outerPadding
            for col in 0..<SLGameSetings.columns {
                
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
    
/*This function is used setup cursor. It helps to keep track of your tap position
    1. Init cursor
    2. Add it to the canvas*/
    func setupCursor(x: Float, y:Float) {
        self.cursor = SLCursor(x: self.canvasInfo.centerX, y: y-15, radius: 20)
        cursor!.color = SLGameSetings.cursorColor
        canvas.addNode(shape: cursor!)
    }
    
/*This function sets up top and bottom bar
    1. Top bar holds player1 and player2
    2. Bottom bar holds restart and menu button*/
    func setupOtherViews() {
        self.setupTopBar()
        self.setupBottomBar()
    }
    
/*This bar holds buttons
    1. Create Restart buttons
    2. Create Menu buttons
    3. Add Autolayout constraints*/
    func setupBottomBar() {
        
        let holder = SLPocket.getView(color: .white)
        self.canvas.addSubview(holder)
        SLPocket.addConstraints(leading: 10, trailing: -10, bottom: -60, height: 100, view: holder)
        
        let restartButton = SLPocket.getButton(title: "RESTART", background: player1.color, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        holder.addSubview(restartButton)
        restartButton.addTarget(self, action: #selector(restartTapped), for: .touchDown)
        SLPocket.addConstraints(leading: 0, top: 0, bottom: 0, widthMultiplier: 0.5, view: restartButton)
        
        let menuButton = SLPocket.getButton(title: "MENU", background: player2.color, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchDown)
        holder.addSubview(menuButton)
        SLPocket.addConstraints(trailing: 0, top: 0, bottom: 0, widthMultiplier: 0.5, view: menuButton)
    }
    
/*This func sets top bar that holds players info
    1. Create player1 button
    2. Create player2 button
    2. Add auto layout constraints*/
    func setupTopBar() {
        
        let holder = SLPocket.getView(color: .white)
        self.canvas.addSubview(holder)
        SLPocket.addConstraints(leading: 10, trailing: -10, top: 60, height: 100, view: holder)
        
        player1Button = SLPocket.getButton(title: player1.name, background: player1.color, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        holder.addSubview(player1Button)
        player1Button.addTarget(self, action: #selector(restartTapped), for: .touchDown)
        SLPocket.addConstraints(leading: 0, top: 0, bottom: 0, widthMultiplier: 0.5, view: player1Button)
        
        player2Button = SLPocket.getButton(title: player2.name, background: player2.color, titleColor: SLGameSetings.fontColor, font: UIFont(name: SLGameSetings.fontName, size: 18)!)
        player2Button.addTarget(self, action: #selector(menuTapped), for: .touchDown)
        holder.addSubview(player2Button)
        SLPocket.addConstraints(trailing: 0, top: 0, bottom: 0, widthMultiplier: 0.5, view: player2Button)
    }
}

//MARK: - Canvas Column Blocks
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


//MARK: - Click Methods
extension ViewController {
    
/*This funct is used to restart the game.
    1. Call reset function
    2. *Also make sure to clear the game label  */
    @objc func restartTapped() {
        print("Reset the damn game")
        self.resetGame(text: " ")
    }

/*This function is used get game type menus
    1. Show the Menu*/
    @objc func menuTapped() {
        print("Pop up the menu")
        self.gameMenu.isHidden = false
    }
    
/*This funct is used to restart the game.
    1. Call reset function
    2. *Also make sure to clear the game label  */
    @objc func onePlayersTapped() {
        print("One player tapped")
        self.resetGame(text: " ")
    }

/*This function is used get game type menus
    1. Show the Menu*/
    @objc func twoPlayersTapped() {
        print("Two player tapped")
    }
    
/*This function will hide the menu view*/
    @objc func cancelMenuTapped() {
        print("Cancel menu")
        self.gameMenu.isHidden = true
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

