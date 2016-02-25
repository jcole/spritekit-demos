//
//  PaperAirplaneScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class PaperAirplaneScene: SKScene {

  // bitmasks
  let conformsToFieldMask:UInt32 = 1
  let airplaneMask:UInt32 = 2

  // MARK: Lifecycle
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
  }

}
