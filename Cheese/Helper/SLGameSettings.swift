//
//  SLGameSettings.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import Foundation
import UIKit

public class SLGameSetings: NSObject {
    
//MARK: - Create a shared device object
    static let shared = SLGameSetings()

//MARK: - Create Colors
    public static var canvasColor = UIColor.white
    
    public static var columnColor = UIColor.white
   
    public static var columnHighlightColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)  //224
}
