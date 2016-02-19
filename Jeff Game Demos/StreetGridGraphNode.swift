//
//  StreetGridGraphNode.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/19/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import GameKit

class StreetGridGraphNode: GKGraphNode2D {

  override func estimatedCostToNode(node: GKGraphNode) -> Float {
    return 1.0
  }

  override func costToNode(node: GKGraphNode) -> Float {
    return 1.0
  }
  
}
