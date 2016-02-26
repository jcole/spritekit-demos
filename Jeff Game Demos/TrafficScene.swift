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

class TrafficScene: SKScene {

  // entities
  var streetGraph:GKGridGraph!
  var cars = [CarEntity]()

  // constants
  var roadRadius:CGFloat = 20.0

  // state
  var lastUpdateTimeInterval:NSTimeInterval?

  // MARK: Lifecycle

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    setup()
  }

  func setup() {
    self.backgroundColor = UIColor.whiteColor()

    createStreetGraph()
    drawStreetGrid()
    setupCars()
  }

  // Entities

  func setupCars() {
    let nodes = streetGraph.nodes as! [GKGraphNode2D]

    cars.append(CarEntity(color: UIColor.redColor()))
    cars.append(CarEntity(color: UIColor.blueColor()))
    cars.append(CarEntity(color: UIColor.greenColor()))
    cars.append(CarEntity(color: UIColor.purpleColor()))

    for car in cars {
      self.addChild(car.node)
    }

    startCar(cars[0], startNode:nodes[0], endNode:nodes[4])
    startCar(cars[1], startNode:nodes[2], endNode:nodes[3])
    startCar(cars[2], startNode:nodes[4], endNode:nodes[2])
    startCar(cars[3], startNode:nodes[3], endNode:nodes[0])
  }

  func startCar(car:CarEntity, startNode:GKGraphNode2D, endNode:GKGraphNode2D) {
    // path for car
    let pathNodes = streetGraph.findPathFromNode(startNode, toNode: endNode) as! [GKGraphNode2D]

    // add behavior
    if !pathNodes.isEmpty {
      let path = GKPath(graphNodes: pathNodes, radius: Float(roadRadius))
      car.start(startNode.position, path:path, allCars:cars)
    }
  }

  func createStreetGraph() {
    let nodes = [
      StreetGridGraphNode(point: vector2(200.0, 50.0)),

      StreetGridGraphNode(point: vector2(200.0, 200.0)),
      StreetGridGraphNode(point: vector2(50.0, 200.0)),
      StreetGridGraphNode(point: vector2(300.0, 200.0)),

      StreetGridGraphNode(point: vector2(200.0, 400.0))
    ]

    nodes[0].addConnectionsToNodes([nodes[1], nodes[3]], bidirectional: true)
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
          line.strokeColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
          line.fillColor = UIColor.whiteColor()
          line.lineWidth = 2.0//roadRadius * 1.0
          
          self.addChild(line)
        }

        // add circles
        let circle = SKShapeNode(circleOfRadius: 5.0)
        circle.position = CGPoint(position:node.position)
        circle.lineWidth = 1.0
        circle.strokeColor = UIColor.blueColor()
        circle.fillColor = UIColor.cyanColor()
        self.addChild(circle)
      }
    }
  }

  // MARK: Update per frame
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)

    // No updates to perform if this scene isn't being rendered
    guard view != nil else { return }

    // Calculate the amount of time since update was last called
    if lastUpdateTimeInterval == nil {
      lastUpdateTimeInterval = currentTime
      return
    }

    let deltaTime = currentTime - lastUpdateTimeInterval!
    lastUpdateTimeInterval = currentTime

    for car in cars {
      car.updateWithDeltaTime(deltaTime)
    }
  }

}
