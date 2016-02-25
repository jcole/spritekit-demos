//
//  StackScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class StackScene: SKScene {

  // entities
  var selectedEntity:SKNode?

  // bitmasks
  let draggableCategory:UInt32 = 1

  // MARK: Lifecycle

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)

    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
  }

  // MARK: Touches
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if selectedEntity != nil {
      selectedEntity!.physicsBody?.affectedByGravity = true
      selectedEntity = nil
    }
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //TODO: Check for all touches.
    //  1) If multiple on different objects, move both objects
    //  2) If multiple on same object, rotate object (calc angle from touch positions)

    if let touch = touches.first {
      let positionInScene = touch.locationInNode(self)

      var touchedNode:SKNode!
      if selectedEntity != nil {
        touchedNode = selectedEntity
      } else {
        touchedNode = self.nodeAtPoint(positionInScene)
      }

      if let category = touchedNode.physicsBody?.categoryBitMask {
        if category == draggableCategory {
          if selectedEntity == nil || selectedEntity == touchedNode {
            //TODO don't allow movements that cause object collision.
            selectedEntity = touchedNode
            touchedNode.position = positionInScene
            touchedNode.physicsBody!.affectedByGravity = false
          }
        }
      }
    }
    
    super.touchesBegan(touches, withEvent:event)
  }

}
