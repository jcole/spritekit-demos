//
//  SwingScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class SwingScene: SKScene {

  // nodes and joints
  var movingNode:SKNode!
  var anchorNode:SKNode?
  var joint:SKPhysicsJointLimit?

  // constants
  let jointMinLength:CGFloat = 50.0

  // bitmasks
  let staticCategory:UInt32 = 1

  // MARK: Lifecycle
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)

    movingNode = self.childNodeWithName("MovingNode")
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
  }

  override func didSimulatePhysics() {
    super.didSimulatePhysics()

    updateJointLength()
  }

  //TODO: Draw line showing joint if it exists.
  //TODO: Losing collision bit masks?
  //TODO: Draw joint at touch position, not node position?
  
  // MARK: Drawing methods

  func maxJointLength(nodeA:SKNode, nodeB:SKNode) -> CGFloat {
    return nodeA.position.distance(nodeB.position)
  }

  func updateJointLength() {
    if joint != nil && anchorNode != nil {
      if joint!.maxLength > jointMinLength {
        self.physicsWorld.removeJoint(joint!)

        joint = SKPhysicsJointLimit.jointWithBodyA(anchorNode!.physicsBody!, bodyB: movingNode.physicsBody!,
          anchorA: anchorNode!.position, anchorB: movingNode.position)
        let newMaxLength = joint!.maxLength * 0.99
        joint?.maxLength = newMaxLength
        self.physicsWorld.addJoint(joint!)
      }
    }
  }

  // MARK: Touches

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let positionInScene = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(positionInScene)

      if let anchorNodeBody = touchedNode.physicsBody {
        if anchorNodeBody.categoryBitMask == staticCategory {
          anchorNode = touchedNode
          joint = SKPhysicsJointLimit.jointWithBodyA(anchorNodeBody, bodyB: movingNode.physicsBody!,
            anchorA: anchorNode!.position, anchorB: movingNode.position)
          joint?.maxLength = maxJointLength(anchorNode!, nodeB:movingNode)
          self.physicsWorld.addJoint(joint!)
        }
      }
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if joint != nil {
      self.physicsWorld.removeJoint(joint!)
      joint = nil
      anchorNode = nil
    }
  }

}
