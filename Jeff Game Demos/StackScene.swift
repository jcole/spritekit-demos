//
//  StackScene.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class StackScene: SKScene {

  // entities
  var selectedEntity:SKNode?

  // bitmasks
  let draggableCategory:UInt32 = 0x1 << 1

  // MARK: Lifecycle

  override init(size: CGSize) {
    super.init(size: size)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() {
    self.physicsWorld.gravity = CGVector(dx: 0, dy: -4.0)
    self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)

    let images = ["circle", "letter-l", "square", "box"]
    for (index, image) in images.enumerate() {
      let sprite = createPhysicsSprite(image)
      let offset = CGFloat(index + 1) * 0.2
      sprite.position = CGPoint(x: self.size.width * offset, y: self.size.height * offset)
      self.addChild(sprite)
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
      let positionInScene = touch.locationInNode(self)

      var touchedNode:SKNode!
      if selectedEntity != nil {
        touchedNode = selectedEntity
      } else {
        touchedNode = self.nodeAtPoint(positionInScene)
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
