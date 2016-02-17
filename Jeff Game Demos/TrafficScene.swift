//
//  TrafficScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/17/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

// bitmasks
let TrafficBitMaskObstacle:UInt32 = 0x1 << 1
let TrafficBitMaskCar:UInt32 = 0x1 << 2

class TrafficScene: SKScene {

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

    // we put contraints on the top, left, right, bottom
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)

    self.backgroundColor = UIColor.whiteColor()

    addCar()
  }

  // Entities

  func addCar() {
    let car = CarEntity()
    car.node.position = CGPoint(x: self.frame.size.width / 2.0, y: 0.0)
    car.node.physicsBody?.velocity = CGVector(dx: 0.0, dy: 50.0)
    self.addChild(car.node)
  }

}
