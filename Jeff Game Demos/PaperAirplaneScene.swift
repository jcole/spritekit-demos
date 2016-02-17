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
  let conformsToFieldMask:UInt32 = 0x1 << 1
  let airplaneMask:UInt32 = 0x1 << 2

  // MARK: Lifecycle

  override init(size: CGSize) {
    super.init(size: size)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    self.physicsWorld.gravity = CGVectorMake(0, 0)

    // we put contraints on the top, left, right, bottom so that our balls can bounce off them
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)

    // airplane
    var airplanePath:CGPath {
      let bezierPath = UIBezierPath()
      bezierPath.moveToPoint(CGPointMake(0.0, 0.0))
      bezierPath.addLineToPoint(CGPointMake(30.0, 0.0))
      bezierPath.addLineToPoint(CGPointMake(15.0, 40.0))
      bezierPath.addLineToPoint(CGPointMake(0.0, 0.0))
      bezierPath.closePath()
      return bezierPath.CGPath
    }

    let airplaneShape = SKShapeNode(path: airplanePath)
    airplaneShape.strokeColor = UIColor.whiteColor()
    airplaneShape.fillColor = UIColor.redColor()
    airplaneShape.lineWidth = 1
    airplaneShape.position = CGPoint(x:self.frame.size.width/2.0, y:10.0)
    self.addChild(airplaneShape)

    airplaneShape.physicsBody = SKPhysicsBody(polygonFromPath: airplanePath)
    airplaneShape.physicsBody?.dynamic = true
    airplaneShape.physicsBody!.mass = 1.0
    airplaneShape.physicsBody!.charge = 1.0
    airplaneShape.physicsBody!.categoryBitMask = airplaneMask
    airplaneShape.physicsBody!.collisionBitMask = airplaneMask
    airplaneShape.physicsBody!.fieldBitMask = conformsToFieldMask
    airplaneShape.physicsBody!.allowsRotation = true
    airplaneShape.physicsBody!.friction = 0.0
    airplaneShape.physicsBody!.restitution = 1.0
    airplaneShape.physicsBody!.velocity = CGVector(dx: 0.0, dy: 50.0)

    // repelling node
    let repellingNodePosition = CGPoint(x: self.frame.size.width - 100.0, y: 150)
    let repellingIconRadius:CGFloat = 10.0

    let repellingNode = SKFieldNode.radialGravityField()
    repellingNode.falloff = 2.0
    repellingNode.strength = -0.1
    repellingNode.position = repellingNodePosition
    self.addChild(repellingNode)

    let repellingShape = SKShapeNode(circleOfRadius: repellingIconRadius)
    repellingShape.strokeColor = UIColor.yellowColor()
    repellingShape.fillColor = UIColor.greenColor()
    repellingShape.lineWidth = 1
    repellingShape.position = repellingNodePosition
    self.addChild(repellingShape)

    // attracting node
    let gravityNodePosition = CGPoint(x:self.frame.size.width - 50.0, y:self.frame.size.height - 100)
    let gravityIconRadius:CGFloat = 10.0

    let gravityNode = SKFieldNode.radialGravityField()
    gravityNode.strength = 0.5
    gravityNode.position = gravityNodePosition
    self.addChild(gravityNode)

    let gravityShape = SKShapeNode(circleOfRadius: gravityIconRadius)
    gravityShape.strokeColor = UIColor.whiteColor()
    gravityShape.fillColor = UIColor.cyanColor()
    gravityShape.lineWidth = 1
    gravityShape.position = gravityNodePosition
    self.addChild(gravityShape)
  }

}
