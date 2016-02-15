//
//  CGPointExtension.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit

extension CGPoint {

  //http://stackoverflow.com/questions/21251706/ios-spritekit-how-to-calculate-the-distance-between-two-nodes
  /**
   Calculates a distance to the given point.

   :param: point - the point to calculate a distance to

   :returns: distance between current and the given points
   */
  func distance(point: CGPoint) -> CGFloat {
    let dx = self.x - point.x
    let dy = self.y - point.y
    return sqrt(dx * dx + dy * dy);
  }
  
}