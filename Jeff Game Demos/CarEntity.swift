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
  var color = UIColor.redColor()

  convenience init(color:UIColor) {
    self.init()

    self.color = color

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
    self.node.strokeColor = UIColor.blackColor()
    self.node.fillColor = self.color
    self.node.lineWidth = 1
  }

  // MARK: GKAgentDelegate methods

  func agentWillUpdate(agent: GKAgent) {

  }

  func agentDidUpdate(agent: GKAgent) {
    self.node.zRotation = CGFloat(self.agent.rotation)

//    let offsetDistance:CGFloat = 20.0
//    let offsetX:CGFloat = sin(self.node.zRotation) * offsetDistance
//    let offsetY:CGFloat = -1 * cos(self.node.zRotation) * offsetDistance

    let nodePosition = CGPointMake(
      CGFloat(self.agent.position.x),
      CGFloat(self.agent.position.y)
    )

    self.node.position = nodePosition
  }

  // MARK: Public methods

  func setPosition(position:vector_float2) {
    node.position = CGPoint(position:position)
    agent.position = position
  }

  func start(startPosition:vector_float2, path:GKPath, allCars:[CarEntity]) {
    setPosition(startPosition)

    var agents = [GKAgent]()
    for car in allCars {
      if car != self {
        agents.append(car.agent)
      }
    }

    let targetSpeedGoal = GKGoal(toReachTargetSpeed: agent.maxSpeed)

    // The "follow path" goal tries to keep the agent facing in a forward direction
    // when it is on this path.
    let followPathGoal = GKGoal(toFollowPath: path, maxPredictionTime: 1.0, forward: true)

    // The "stay on path" goal tries to keep the agent on the path within the path's radius.
    let stayOnPathGoal = GKGoal(toStayOnPath: path, maxPredictionTime: 1.0)

    let behavior = GKBehavior()

    behavior.setWeight(0.1, forGoal: targetSpeedGoal)
    behavior.setWeight(1.0, forGoal: followPathGoal)
    behavior.setWeight(1.0, forGoal: stayOnPathGoal)

    agent.behavior = behavior
  }
}
