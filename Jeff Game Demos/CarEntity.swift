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

  private func setAgent() {
    agent = GKAgent2D()
    agent.delegate = self
    agent.maxSpeed = 40.0
    agent.maxAcceleration = 5.0
    agent.mass = 0.1
    agent.radius = Float(5.0)
    agent.position = vector2(Float(self.node.position.x), Float(self.node.position.y))
    addComponent(agent!)
  }

  private func setNode() {
    let width:CGFloat = 30.0
    let height:CGFloat = 20.0

    // Arrow facing to right
    var carCGPath:CGPath {
      let bezierPath = UIBezierPath()
      bezierPath.moveToPoint(CGPointMake(-width/2.0, height/2.0))
      bezierPath.addLineToPoint(CGPointMake(width/2.0, 0.0))
      bezierPath.addLineToPoint(CGPointMake(-width/2.0, -height/2.0))
      bezierPath.closePath()
      return bezierPath.CGPath
    }

    self.node = SKShapeNode(path: carCGPath, centered: true)
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

  // MARK: Public methods

  func setPosition(position:vector_float2) {
    node.position = CGPoint(position:position)
    agent.position = position
  }

  func setPath(path:GKPath) {
    let targetSpeedGoal = GKGoal(toReachTargetSpeed: agent.maxSpeed)
    let followPathGoal = GKGoal(toFollowPath: path, maxPredictionTime: 1.0, forward: true)
    let stayOnPathGoal = GKGoal(toStayOnPath: path, maxPredictionTime: 1.0)

    let behavior = GKBehavior()

    behavior.setWeight(0.5, forGoal: targetSpeedGoal)
    behavior.setWeight(1.0, forGoal: followPathGoal)
    behavior.setWeight(1.0, forGoal: stayOnPathGoal)

    agent.behavior = behavior
  }

}
