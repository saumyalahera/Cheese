//
//  ViewController.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get command Queue
        guard let device = SLPocket.createDevice(), let queue = SLPocket.createCommandQueue(device: device) else {
            return
        }
        SLTools.setupMetalComponents(device: device, queue: queue)
        
        //Create canvas and add circles to it
        //Create a paper view
        let canvas = SLCanvas(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        canvas.color = UIColor.white
        self.view.addSubview(canvas)
        
    //Create a grid
        
        let center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        /*let center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        
        var padding = 15
        
        var x = center.x - ((padding*2)+50
        
        for _ in 0..<6 {
            
            for _ in 0..<7 {
                
            }
        }
        */
        
        
        let padding:Float = 5
        let containerDimension:Float = 50
        let boardHeight = (6*containerDimension)+(5*padding)
        let boardWidth = (7*containerDimension)+(6*padding)
        var x = Float(center.x) - (boardWidth/2)
        var y = Float(center.y) - (boardHeight/2)
        
        for _ in 0..<6 {
            x=Float(center.x) - (boardWidth/2)
            for _ in 0..<7 {
                let s1 = SLSquare(x: x, y: y, width: containerDimension, height: containerDimension)
                s1.color = .gray.withAlphaComponent(0.1)
                canvas.addNode(shape: s1)
                x+=(padding+containerDimension)
            }
            y+=(padding+containerDimension)
        }
        
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
        
        
        
    }

}

