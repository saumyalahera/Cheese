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
        // Do any additional setup after loading the view.
        
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
        
        
        //Create a circle - Super buggy
        let c1 = SLCircle(x: 0, y: 600, radius: 0.3)
        c1.color = .purple
        canvas.addNode(shape: c1)
    }

}

