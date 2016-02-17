//
//  FieldsDemoScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/17/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class FieldsDemoScene: SKScene {

  // entities
  var fieldNode:SKFieldNode?
  var labelNode = SKLabelNode()

  // state
  let numFieldTypes = 10
  var currentFieldType:Int?

  // bitmasks
  let conformsToFieldMask:UInt32 = 0x1 << 1
  let ballMask:UInt32 = 0x1 << 2

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
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(-100, -100, 10000, 10000)) //arbitrarily wide

    labelNode.position = CGPoint(x: self.frame.size.width / 2.0, y: 50)
    labelNode.fontColor = UIColor.cyanColor()
    labelNode.fontSize = 15.0
    self.addChild(labelNode)
  }

  var lastTime:Int64? //ms

  override func didEvaluateActions() {
    let now = Int64(NSDate().timeIntervalSince1970 * 1000)
    if lastTime != nil && (now - lastTime! < 100) {
      return
    }
    lastTime = now

    addCircle()
  }

  // MARK: Gestures

  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    // we grab the UITouch object in the current scene (self) coordinate
    if let touch = touches.first {
      let positionInScene = touch.locationInNode(self)

      // we apply the position of the touch to the physics field node
      switchFieldNode(positionInScene)
    }
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    labelNode.text = nil
    removeFieldNode()
  }

  // MARK: Add entities

  func addCircle() {
    let radius:CGFloat = 2.0

    let shape = SKShapeNode(circleOfRadius: radius)
    shape.strokeColor = UIColor.redColor()
    shape.lineWidth = 1
    shape.fillColor = UIColor.yellowColor()
    let x:CGFloat = 0
    let y:CGFloat = CGFloat(arc4random()%UInt32(self.frame.size.height))
    shape.position = CGPoint(x:x, y:y)
    self.addChild(shape)

    shape.physicsBody = SKPhysicsBody(circleOfRadius: radius)
    shape.physicsBody?.dynamic = true
    shape.physicsBody!.mass = 1.0
    shape.physicsBody!.charge = 1.0
    shape.physicsBody!.categoryBitMask = ballMask
    shape.physicsBody!.collisionBitMask = ballMask
    shape.physicsBody!.fieldBitMask = conformsToFieldMask
    shape.physicsBody!.allowsRotation = true
    shape.physicsBody!.friction = 0.0
    shape.physicsBody!.restitution = 1.0
    shape.physicsBody!.velocity = CGVector(dx: 40.0, dy: 0.0)
  }

  func removeFieldNode() {
    if fieldNode != nil {
      fieldNode!.removeFromParent()
      fieldNode = nil
      return
    }
  }

  func switchFieldNode(position:CGPoint) {
    if currentFieldType == nil {
      currentFieldType = 0
    }

    currentFieldType! += 1
    if currentFieldType! == numFieldTypes {
      currentFieldType = 0
    }

    var node:SKFieldNode!
    var text:String!

    switch currentFieldType! {
    case 0:
      text = "SKFieldNode.magneticField()"
      node = SKFieldNode.magneticField()
    case 1:
      text = "SKFieldNode.electricField()"
      node = SKFieldNode.electricField()
    case 2:
      text = "SKFieldNode.linearGravityFieldWithVector()"
      node = SKFieldNode.linearGravityFieldWithVector(vector3(0.0, -9.8, 0.0))
    case 3:
      text = "SKFieldNode.dragField()"
      node = SKFieldNode.dragField()
    case 4:
      text = "SKFieldNode.noiseFieldWithSmoothness()"
      node = SKFieldNode.noiseFieldWithSmoothness(0.5, animationSpeed: 1.0)
    case 5:
      text = "SKFieldNode.radialGravityField()"
      node = SKFieldNode.radialGravityField()
    case 6:
      text = "SKFieldNode.springField()"
      node = SKFieldNode.springField()
    case 7:
      text = "SKFieldNode.turbulenceFieldWithSmoothness()"
      node = SKFieldNode.turbulenceFieldWithSmoothness(0.5, animationSpeed: 1.0)
    case 8:
      text = "SKFieldNode.velocityFieldWithVector()"
      node = SKFieldNode.velocityFieldWithVector(vector3(0.0, 1.0, 0.0))
    case 9:
      text = "SKFieldNode.vortexField()"
      node = SKFieldNode.vortexField()
    default:
      print("Should not get here")
    }

    labelNode.text = text

    node.strength = 1.0
    node.physicsBody?.fieldBitMask = conformsToFieldMask

    fieldNode = node
    fieldNode!.position = position
    self.addChild(fieldNode!)
  }

}
