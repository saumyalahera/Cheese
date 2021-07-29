//
//  ViewController.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import UIKit

class ViewController: UIViewController {

    var canvas:SLCanvas!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get command Queue
        guard let device = SLPocket.createDevice(), let queue = SLPocket.createCommandQueue(device: device) else {
            return
        }
        SLTools.setupMetalComponents(device: device, queue: queue)
        
        //Create canvas and add circles to it
        //Create a paper view
        canvas = SLCanvas(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        canvas.color = UIColor.white
        self.view.addSubview(canvas)
        
        
        self.createCanvasBlocks()
        
    //Create a grid
        
        
        /*let center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        
        var padding = 15
        
        var x = center.x - ((padding*2)+50
        
        for _ in 0..<6 {
            
            for _ in 0..<7 {
                
            }
        }
        */
        
        
        /*let padding:Float = 5
        var containerDimension:Float = 50
        let boardHeight = (6*containerDimension)+(5*padding)
        let boardWidth = (7*containerDimension)+(6*padding)
        var x = Float(center.x) - (boardWidth/2)
        var y = Float(center.y) - (boardHeight/2)
        
        for _ in 0..<6 {
            x=Float(center.x) - (boardWidth/2)
            for _ in 0..<7 {
                let s1 = SLSquare(x: x, y: y, width: containerDimension, height: containerDimension)
                s1.color = SLGameSetings.canvasBlockHighlightColor
                canvas.addNode(shape: s1)
                x+=(padding+containerDimension)
            }
            y+=(padding+containerDimension)
        }*/
        
        /*
        //Create a circle - Super buggy
        let c1 = SLCircle(x: Float(center.x), y: Float(center.y), radius: 0.08)
        c1.color = .purple
        //canvas.addNode(shape: c1)
        
        //Create a squares
        let s1 = SLSquare(x: 20, y: 20, width: 100, height: 100)
        s1.color = .yellow
        canvas.addNode(shape: s1)
        
        let s2 = SLSquare(x: 20, y: 150, width: 100, height: 100)
        s2.color = .red
        canvas.addNode(shape: s2)
        */
        /*let s1 = SLSquare(x: 10, y: 10, width: containerDimension, height: containerDimension)
        s1.color = .gray.withAlphaComponent(0.1)*/
        //canvas.addNode(shape: s1)
        
        
    }
    
    
    var canvasBlocks = [SLShape?]()
    var outerPadding:Float = 5
    var innerPadding:Float = 3
    var rows:Float = 6
    var cols:Float = 7
    var columnWidth:Float = 0 //Used to check highlights
    var columnHeight:Float = 0  //Used to check highlights
    var blockDimension:Float = 0
    var screenWidth:Float = 0
    var lastNumber:Int = 0
    
    func createCanvasBlocks() {
        
        self.screenWidth = Float(self.view.frame.width)
    //Calculate block width
        columnWidth = self.screenWidth - (2*outerPadding)
    //Get block width
        blockDimension = columnWidth - ((cols-1)*innerPadding)
        blockDimension/=cols
    //Get block height
        columnHeight = (blockDimension*rows) + ((rows-1)*innerPadding)
    //Get column width
        columnWidth/=cols
    //Coordinates
        var x = outerPadding
        let y:Float = (Float(self.view.center.y))-(columnHeight/2)
    //Setup blocks
        for _ in 0..<Int(cols) {
            let s1 = SLSquare(x: x, y: y, width: columnWidth, height: columnHeight)
            canvas.addNode(shape: s1)
            self.canvasBlocks.append(s1)
            x+=columnWidth
        }
    }
}

extension ViewController {

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ENDDD")
        guard let location = touches.first?.location(in: self.view) else {
            return
        }
        if(location.y <= (self.view.center.y+(CGFloat(self.columnHeight/2)))) {
            let number = Int(Float(location.x)/self.columnWidth)
            
            guard number < Int(cols) else{
                return
            }
            
            guard let shape = self.canvasBlocks[number] else{
                return
            }
            UIView.animate(withDuration: 0, animations: {
                shape.color = SLGameSetings.columnHighlightColor
            }, completion: {_ in
                shape.color = SLGameSetings.columnColor
            })
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("PRESS")
        guard let location = touches.first?.location(in: self.view) else {
            return
        }
        print(location)
        if(location.y <= (self.view.center.y+(CGFloat(self.columnHeight/2)))) {
            let number = Int(Float(location.x)/self.columnWidth)
            print("Number: \(number)")
            guard number < Int(cols) else{
                
                return
            }
            guard let shape = self.canvasBlocks[number] else{
                return
            }
            UIView.animate(withDuration: 0, animations: {
                if(self.lastNumber != number) {
                    //shape.color = SLGameSetings.columnColor
                }
                shape.color = SLGameSetings.columnHighlightColor
            }, completion: {_ in
                
            })
        }
    }
}

