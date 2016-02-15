//
//  SpriteKitSceneViewController.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class SpriteKitSceneViewController: UIViewController {

  var scene:SKScene!

  convenience init(scene:SKScene) {
    self.init()
    self.scene = scene
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setup()
  }

  func setup() {
    let sceneView = SKView(frame: self.view.frame)
    sceneView.showsFPS = true
    sceneView.showsPhysics = true
    self.view.addSubview(sceneView)

    scene.size = self.view.frame.size
    scene.physicsWorld.gravity = CGVector(dx: 0, dy: -4.0)
    scene.physicsBody = SKPhysicsBody(edgeLoopFromRect: scene.frame)
    sceneView.presentScene(scene)
  }
}
