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

  // MARK: Lifecycle
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
  }

}
