//
//  SLNode.swift
//  Cheese
//
//  Created by Saumya Lahera on 7/28/21.
//

import Foundation
import UIKit

/**This is the base class of all the other objects*/
class SLNode: NSObject {

}

protocol SLNodeDelegate {
    func initBuffers()
}
