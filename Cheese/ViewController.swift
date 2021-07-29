//
//  ViewController.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import UIKit

class ViewController: UIViewController {

//MARK: - Cursor Properties
    ///This is used when a user drags or clicks on rows
    var cursor:SLCursor?
    
    ///These are used for cursor and highlights
    var canvasBlocks = [SLShape?]()
    

    ///This is where the main rendering is done
    var canvas:SLCanvas!
    
    ///Canvas info will be used to render subviews
    var canvasInfo = SLCanvasInfo(centerX: 0, centerY: 0, width: 0, height: 0)
    
//MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Get command Queue and device
        guard let device = SLPocket.createDevice(), let queue = SLPocket.createCommandQueue(device: device) else {
            return
        }
        SLTools.setupMetalComponents(device: device, queue: queue)
        
    //Create canvas and add objects on it
        canvas = SLCanvas(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        canvas.color = UIColor.white
        self.view.addSubview(canvas)
        
    //Update canvas information
        self.canvasInfo = SLCanvasInfo(centerX: Float(self.view.center.x), centerY: Float(self.view.center.y), width: Float(self.view.frame.width), height: Float(self.view.frame.height))
        
    //Create canvas blocks, they are used to highlight columns and guides player to drop coins
        self.createCanvasBlocks()
        
    //Create a grid
        let padding:Float = 5
        var containerDimension:Float = 50
        let boardHeight = (6*containerDimension)+(5*padding)
        let boardWidth = (7*containerDimension)+(6*padding)
        var x = Float(self.view.center.x) - (boardWidth/2)
        var y = Float(self.view.center.y) - (boardHeight/2)
        
        self.cursor = SLCursor(x: Float(self.view.center.x), y: y-15, radius: 20)
        cursor!.color = .white
        canvas.addNode(shape: cursor!)
        
        for _ in 0..<6 {
            x=Float(self.view.center.x) - (boardWidth/2)
            for _ in 0..<7 {
                let s1 = SLSquare(x: x, y: y, width: containerDimension, height: containerDimension)
                s1.color = SLGameSetings.columnHighlightColor
                canvas.addNode(shape: s1)
                x+=(padding+containerDimension)
            }
            y+=(padding+containerDimension)
        }
    }
    
    
    
    var outerPadding:Float = 5
    var innerPadding:Float = 3
    var rows:Float = 6
    var cols:Float = 7
    var columnWidth:Float = 0 //Used to check highlights
    var columnHeight:Float = 0  //Used to check highlights
    //var blockDimension:Float = 0
    var columnBlocksCenterPositions = [Float]()
    
   
    func createCanvasBlocks() {
        
        //self.screenWidth = Float(self.view.frame.width)
    //Calculate block width
        columnWidth = self.canvasInfo.width - (2*outerPadding)
    //Get block width
        var blockDimension = columnWidth - ((cols-1)*innerPadding)
        blockDimension/=cols
    //Get block height
        columnHeight = (blockDimension*rows) + ((rows-1)*innerPadding)
    //Get column width
        columnWidth/=cols
    //Coordinates
        var x = outerPadding
        let y = (self.canvasInfo.centerY)-(columnHeight/2)
    //Setup blocks
        for _ in 0..<Int(cols) {
            let s1 = SLSquare(x: x, y: y, width: columnWidth, height: columnHeight)
            canvas.addNode(shape: s1)
            self.columnBlocksCenterPositions.append(x+(columnWidth/2))
            self.canvasBlocks.append(s1)
            x+=columnWidth
        }
    }
}


/** This extension is used to keep track of cursor and it */
extension ViewController {
    
/**This function returns **/
    func getCursorCenterPositionCounter(x: Float, y:Float) -> Int? {
    //To check if the player is dragging in the zone
        let halfHeight = self.columnHeight/2
        if(y <= (self.canvasInfo.centerY + halfHeight) && y >= (self.canvasInfo.centerY - halfHeight)) {
            
            let counter = Int(x/self.columnWidth)
            
            guard counter < Int(cols) else{
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

