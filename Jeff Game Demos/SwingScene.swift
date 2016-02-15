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

  // bitmasks
  let collideableCategory:UInt32 = 0x1 << 1

  // MARK: Lifecycle

  override init(size: CGSize) {
    super.init(size: size)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    self.addChild(createBoxSprite(CGSize(width: 100, height: 20), position:CGPoint(x:100, y:200)))
    self.addChild(createBoxSprite(CGSize(width: 30, height: 40), position:CGPoint(x:220, y:200)))
    self.addChild(createBoxSprite(CGSize(width: 200, height: 10), position:CGPoint(x:300, y:300)))

    movingNode = SKShapeNode(circleOfRadius: 40.0)
    movingNode.position = CGPoint(x: 200, y: 40)
    movingNode.physicsBody = SKPhysicsBody(circleOfRadius: 40.0)
    movingNode.physicsBody?.dynamic = true
    movingNode.physicsBody!.categoryBitMask = collideableCategory
    movingNode.physicsBody!.collisionBitMask = collideableCategory
    movingNode.physicsBody!.contactTestBitMask = collideableCategory
    self.addChild(movingNode)
  }

  // MARK: Drawing methods

  func createBoxSprite(size:CGSize, position:CGPoint) -> SKNode {
    let shape = SKShapeNode(rectOfSize: size, cornerRadius: 2)
    shape.strokeColor = SKColor.blueColor()
    shape.lineWidth = 4
    shape.position = position

    shape.physicsBody = SKPhysicsBody(rectangleOfSize: size)
    shape.physicsBody?.dynamic = false

    shape.physicsBody!.categoryBitMask = collideableCategory
    shape.physicsBody!.collisionBitMask = collideableCategory
    shape.physicsBody!.contactTestBitMask = collideableCategory

    return shape
  }

  func maxJointLength(nodeA:SKNode, nodeB:SKNode) -> CGFloat {
    return nodeA.position.distance(nodeB.position)
  }

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let positionInScene = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(positionInScene)

      if let anchorNodeBody = touchedNode.physicsBody {
        anchorNode = touchedNode
        joint = SKPhysicsJointLimit.jointWithBodyA(anchorNodeBody, bodyB: movingNode.physicsBody!,
          anchorA: anchorNode!.position, anchorB: movingNode.position)
        joint?.maxLength = maxJointLength(anchorNode!, nodeB:movingNode)
        self.physicsWorld.addJoint(joint!)
      }
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if joint != nil {
      self.physicsWorld.removeJoint(joint!)
    }
  }

}
