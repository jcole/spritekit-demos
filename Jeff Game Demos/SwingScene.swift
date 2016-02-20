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
  let movingCategory:UInt32 = 0x1 << 1
  let staticCategory:UInt32 = 0x1 << 2

  // MARK: Init

  override init(size: CGSize) {
    super.init(size: size)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -4.0)
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)

    self.addChild(createBoxSprite(CGSize(width: 100, height: 80), position:CGPoint(x:0, y:200)))
    self.addChild(createBoxSprite(CGSize(width: 80, height: 80), position:CGPoint(x:220, y:300)))
    self.addChild(createBoxSprite(CGSize(width: 200, height: 100), position:CGPoint(x:0, y:450)))
    self.addChild(createBoxSprite(CGSize(width: 200, height: 100), position:CGPoint(x:400, y:550)))

    movingNode = SKShapeNode(circleOfRadius: 40.0)
    movingNode.position = CGPoint(x: 200, y: 40)
    movingNode.physicsBody = SKPhysicsBody(circleOfRadius: 40.0)
    movingNode.physicsBody?.dynamic = true
    movingNode.physicsBody!.categoryBitMask = movingCategory
    movingNode.physicsBody!.collisionBitMask = staticCategory
    movingNode.physicsBody!.contactTestBitMask = staticCategory
    self.addChild(movingNode)
  }

  // MARK: Lifecycle

  override func didSimulatePhysics() {
    super.didSimulatePhysics()

    updateJointLength()
  }

  // MARK: Drawing methods

  func createBoxSprite(size:CGSize, position:CGPoint) -> SKNode {
    let shape = SKShapeNode(rectOfSize: size, cornerRadius: 2)
    shape.strokeColor = SKColor.blueColor()
    shape.lineWidth = 4
    shape.position = position

    shape.physicsBody = SKPhysicsBody(rectangleOfSize: size)
    shape.physicsBody?.dynamic = false

    shape.physicsBody!.categoryBitMask = staticCategory
    shape.physicsBody!.collisionBitMask = movingCategory
    shape.physicsBody!.contactTestBitMask = movingCategory

    return shape
  }

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
