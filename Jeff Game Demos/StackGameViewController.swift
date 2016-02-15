//
//  StackGameViewController.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class StackGameViewController: UIViewController {

  // spritekit
  var sceneView:SKView!
  var scene:SKScene!

  // entities
  var selectedEntity:SKNode?

  // bitmasks
  let draggableCategory:UInt32 = 0x1 << 1

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

    let images = ["circle", "letter-l", "square", "box"]
    for (index, image) in images.enumerate() {
      let sprite = createPhysicsSprite(image)
      let offset = CGFloat(index + 1) * 0.2
      sprite.position = CGPoint(x: scene.size.width * offset, y: scene.size.height * offset)
      scene.addChild(sprite)
    }
  }

  func createPhysicsSprite(imageName:String) -> SKSpriteNode {
    let sprite = SKSpriteNode(imageNamed:imageName)
    sprite.name = imageName
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody!.categoryBitMask = draggableCategory
    sprite.physicsBody!.collisionBitMask = draggableCategory
    sprite.physicsBody!.contactTestBitMask = draggableCategory

    return sprite
  }

  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if selectedEntity != nil {
      selectedEntity!.physicsBody?.affectedByGravity = true
      selectedEntity = nil
    }
  }

  override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if let touch = touches.first {
      let positionInScene = touch.locationInNode(scene)

      var touchedNode:SKNode!
      if selectedEntity != nil {
        touchedNode = selectedEntity
      } else {
        touchedNode = scene.nodeAtPoint(positionInScene)
      }

      if let category = touchedNode.physicsBody?.categoryBitMask {
        if category == draggableCategory {
          if selectedEntity == nil || selectedEntity == touchedNode {
            //TODO don't allow movements that cause object collision.
            selectedEntity = touchedNode
            touchedNode.position = positionInScene
            touchedNode.physicsBody!.affectedByGravity = false
          }
        }
      }
    }

    super.touchesBegan(touches, withEvent:event)
  }

}
