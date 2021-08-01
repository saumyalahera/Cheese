//
//  SLGameSettings.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/29/21.
//

import Foundation
import UIKit

public class SLGameSettings: NSObject {
    
//MARK: - Create a shared device object
    static let shared = SLGameSettings()

//MARK: - Create Colors
    public static var canvasColor = UIColor.white
    
    public static var columnColor = UIColor.white
   
    public static var columnHighlightColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)  //224
    
    public static var cursorColor = UIColor.white
    
    public static var cursorHighlightColor = UIColor.black
//SML
    public static var gameType = SLGameType.TwoPlayer
    
    public static var playerOneCoinColor = UIColor(red: 195/255, green: 189/255, blue: 232/255, alpha: 1) //UIColor.red
    
    public static var playerTwoCoinColor = UIColor(red: 196/255, green: 246/255, blue: 201/255, alpha: 1) //UIColor.yellow
    
    public static var defaultCoinColor = UIColor.white
    
    public static var fontName = "Avenir Next Bold"
    
    public static var fontColor = UIColor.black
    
    public static var lightPurpleColor = UIColor(red: 195/255, green: 189/255, blue: 232/255, alpha: 1)
    
    public static var lightGreenColor = UIColor(red: 196/255, green: 246/255, blue: 201/255, alpha: 1)
    
    public static var columns = 7
    
    public static var rows = 6
    
    
}
