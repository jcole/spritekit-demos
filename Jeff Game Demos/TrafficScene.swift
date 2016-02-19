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
  var streetGraph:GKGridGraph!
  var car:CarEntity!

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

    createStreetGraph()
    drawStreetGrid()
    addCar()
  }

  // Entities

  func createStreetGraph() {
    let nodes = [
      StreetGridGraphNode(point: vector2(200.0, 50.0)),

      StreetGridGraphNode(point: vector2(200.0, 200.0)),
      StreetGridGraphNode(point: vector2(50.0, 200.0)),
      StreetGridGraphNode(point: vector2(300.0, 200.0)),

      StreetGridGraphNode(point: vector2(200.0, 400.0))
    ]

    nodes[0].addConnectionsToNodes([nodes[1]], bidirectional: true)
    nodes[1].addConnectionsToNodes([nodes[2], nodes[3]], bidirectional: true)
    nodes[4].addConnectionsToNodes([nodes[1]], bidirectional: true)

    streetGraph = GKGridGraph(nodes: nodes)
  }

  func drawStreetGrid() {
    // draw on screen
    if let nodes = streetGraph.nodes as? [GKGraphNode2D] {
      for node in nodes {
        // connect lines
        for connectedNode in node.connectedNodes as! [GKGraphNode2D] {
          let path = CGPathCreateMutable()
          CGPathMoveToPoint(path, nil, CGFloat(node.position.x), CGFloat(node.position.y))
          CGPathAddLineToPoint(path, nil, CGFloat(connectedNode.position.x), CGFloat(connectedNode.position.y))
          CGPathCloseSubpath(path)

          let line = SKShapeNode()
          line.path = path
          line.strokeColor = UIColor.yellowColor()
          line.lineWidth = 1
          
          self.addChild(line)
        }

        // add circles
        let circle = SKShapeNode(circleOfRadius: roadRadius)
        circle.position = CGPoint(position:node.position)
        circle.lineWidth = 1.0
        circle.strokeColor = UIColor.blueColor()
        circle.fillColor = UIColor.cyanColor()
        self.addChild(circle)
      }
    }
  }

  func addCar() {
    car = CarEntity()
    self.addChild(car.node)

    // path for car
    let nodes = streetGraph.nodes as! [GKGraphNode2D]
    let startNode = nodes[0]
    let endNode = nodes[nodes.count - 1]
    let pathNodes = streetGraph.findPathFromNode(startNode, toNode: endNode)  as! [GKGraphNode2D]

    // position
    car.setPosition(startNode.position)

    // add behavior
    if !pathNodes.isEmpty {
      let path = GKPath(graphNodes: pathNodes, radius: Float(roadRadius))
      car.setPath(path)
    }
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
