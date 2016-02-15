//
//  SwingViewController.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class SwingViewController: UIViewController {

  // spritekit
  var sceneView:SKView!
  var scene:SKScene!

  // bitmasks
  let collideableCategory:UInt32 = 0x1 << 1

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
  }

  func setup() {
    sceneView = SKView(frame: self.view.frame)
    sceneView.showsFPS = true
    sceneView.showsPhysics = true
    self.view.addSubview(sceneView)

    scene = SKScene(size: self.view.frame.size)
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -4.0)
    scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: scene.frame)
    sceneView.presentScene(scene)

    scene.addChild(createBoxSprite(CGSize(width: 100, height: 20), position:CGPoint(x:100, y:200)))
    scene.addChild(createBoxSprite(CGSize(width: 30, height: 40), position:CGPoint(x:220, y:200)))
    scene.addChild(createBoxSprite(CGSize(width: 200, height: 10), position:CGPoint(x:300, y:300)))

    let shape = SKShapeNode(circleOfRadius: 40.0)
    shape.position = CGPoint(x: 200, y: 40)
    shape.physicsBody = SKPhysicsBody(circleOfRadius: 40.0)
    shape.physicsBody?.dynamic = true
    shape.physicsBody!.categoryBitMask = collideableCategory
    shape.physicsBody!.collisionBitMask = collideableCategory
    shape.physicsBody!.contactTestBitMask = collideableCategory
    scene.addChild(shape)
  }

  func createBoxSprite(size:CGSize, position:CGPoint) -> SKNode {
    let shape = SKShapeNode(rectOfSize: size, cornerRadius: 2)
    shape.strokeColor = SKColor.blueColor()
    shape.lineWidth = 4
    shape.position = position

    shape.physicsBody = SKPhysicsBody(rectangleOfSize: size)
    shape.physicsBody?.dynamic = false

    shape.physicsBody!.categoryBitMask = collideableCategory
    shape.physicsBody!.collisionBitMask = collideableCategory
    shape.physicsBody!.contactTestBitMask = collideableCategory
    
    return shape
  }

}
