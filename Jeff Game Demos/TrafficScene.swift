//
//  TrafficScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/17/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

// bitmasks
let TrafficBitMaskObstacle:UInt32 = 0x1 << 1
let TrafficBitMaskCar:UInt32 = 0x1 << 2

class TrafficScene: SKScene {

  // entities
  var path:GKPath!
  let car = CarEntity()

  // constants
  var roadRadius:CGFloat = 5.0

  // state
  var lastUpdateTimeInterval: NSTimeInterval = 0

  // MARK: Lifecycle

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    setup()
  }

  func setup() {
    self.physicsWorld.gravity = CGVectorMake(0, 0)

    self.backgroundColor = UIColor.whiteColor()

    addPath()
    addCar()
  }

  // Entities

  func addPath() {
    //TODO use GKGridGraph 
    // https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/GameplayKit_Guide/Pathfinding.html#//apple_ref/doc/uid/TP40015172-CH3-SW1
    let nodes = [
      GKGraphNode2D(point: vector2(10.0, 10.0)),
      GKGraphNode2D(point: vector2(10.0, 50.0)),
      GKGraphNode2D(point: vector2(100.0, 100.0)),
      GKGraphNode2D(point: vector2(100.0, 300.0)),
      GKGraphNode2D(point: vector2(300.0, 300.0)),
      GKGraphNode2D(point: vector2(200.0, 400.0)),
    ]
    path = GKPath(graphNodes: nodes, radius: Float(roadRadius))

    var cgPoints = [CGPoint]()
    for node in nodes {
      cgPoints.append(CGPoint(x: CGFloat(node.position.x), y: CGFloat(node.position.y)))
    }

    let pathShape = SKShapeNode(points: UnsafeMutablePointer(cgPoints), count: cgPoints.count)
    pathShape.lineWidth = 2.0 * roadRadius
    pathShape.strokeColor = UIColor.cyanColor()
    self.addChild(pathShape)
  }

  func addCar() {
    // set up entity
    car.node.position = CGPoint(x: 10.0, y: 10.0)
    self.addChild(car.node)

    // TODO behavior to keep car pointing forward?
    // add behavior
    let behavior = GKBehavior()
    behavior.setWeight(0.5, forGoal: GKGoal(toReachTargetSpeed: car.agent.maxSpeed))
    behavior.setWeight(1.0, forGoal: GKGoal(toFollowPath: path, maxPredictionTime: 0.5, forward: true))
    behavior.setWeight(1.0, forGoal: GKGoal(toStayOnPath: path, maxPredictionTime: 0.5))
    car.agent.behavior = behavior

    // register agent component
  //  agentSystem.addComponentWithEntity(car)
  }

  // MARK: Update per frame
  var numCycles = 0
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)

    // No updates to perform if this scene isn't being rendered
    guard view != nil else { return }

    // Calculate the amount of time since update was last called
    let deltaTime = currentTime - lastUpdateTimeInterval
    lastUpdateTimeInterval = currentTime

    numCycles++
    if numCycles > 2 {
      car.updateWithDeltaTime(deltaTime)
    }
  }

}
