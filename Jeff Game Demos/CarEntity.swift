//
//  CarEntity.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/17/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import GameKit

class CarEntity: GKEntity, GKAgentDelegate {

  var node:SKShapeNode!
  var agent:GKAgent2D!

  override init() {
    super.init()

    setNode()
    setAgent()
  }

  func setAgent() {
    agent = GKAgent2D()
    agent.delegate = self
    agent.maxSpeed = 40.0
    agent.maxAcceleration = 5.0
    agent.mass = 0.1
    agent.radius = Float(5.0)
    agent.position = vector2(Float(self.node.position.x), Float(self.node.position.y))
    addComponent(agent!)
  }

  func setNode() {
    var carCGPath:CGPath {
      let bezierPath = UIBezierPath()
      bezierPath.moveToPoint(CGPointMake(0.0, 0.0))
      bezierPath.addLineToPoint(CGPointMake(30.0, 0.0))
      bezierPath.addLineToPoint(CGPointMake(15.0, 40.0))
      bezierPath.addLineToPoint(CGPointMake(0.0, 0.0))
      bezierPath.closePath()
      return bezierPath.CGPath
    }

    self.node = SKShapeNode(path: carCGPath)
    self.node.strokeColor = UIColor.whiteColor()
    self.node.fillColor = UIColor.redColor()
    self.node.lineWidth = 1

    self.node.physicsBody = SKPhysicsBody(polygonFromPath: carCGPath)
    self.node.physicsBody?.dynamic = true
    self.node.physicsBody!.mass = 1.0
    self.node.physicsBody!.charge = 1.0
    self.node.physicsBody!.categoryBitMask = TrafficBitMaskCar
    self.node.physicsBody!.collisionBitMask = (TrafficBitMaskCar | TrafficBitMaskObstacle)
    self.node.physicsBody!.allowsRotation = true
    self.node.physicsBody!.friction = 0.0
    self.node.physicsBody!.restitution = 1.0
  }

  // MARK: GKAgentDelegate methods

  func agentWillUpdate(agent: GKAgent) {

  }

  func agentDidUpdate(agent: GKAgent) {
    self.node.position = CGPointMake(CGFloat(self.agent.position.x), CGFloat(self.agent.position.y))
    self.node.zRotation = CGFloat(self.agent.rotation)
  }

}
