//
//  ThreeDMarblesViewController.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SceneKit

class ThreeDMarblesViewController: UIViewController, SCNPhysicsContactDelegate, SCNSceneRendererDelegate {

  // scene
  var scene = SCNScene()
  var sceneView:SCNView!
  let camera = SCNCamera()
  let cameraNode = SCNNode()

  enum GameState {
    case Unselected
    case Targeting
    case Moving
  }

  // state
  var cameraTargetingDistanceFromCenter:Float = 25.0
  var mainSphereTargetingDistanceFromCenter:Float = 10.0
  var mainSphereStartingPosition = SCNVector3Zero
  var aimDirection:SCNVector3!
  var aimMagnitude:Float = 50.0
  var state:GameState!

  // entities
  var mainSphere:SCNNode!
  var targetSpheres = [SCNNode]()
  var centerSphere:SCNNode!
  var aimLine:SCNNode!

  // bitmasks
  let sphereCategory:Int = 1  //SceneKit uses Int, SpriteKit uses UInt32

  // constants
  let aimLineHeight:Float = 3.0
  let numSpheres  = 20
  let mainSphereOriginalColor = UIColor.redColor()


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    setup()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func setup() {
    // scene
    scene.physicsWorld.gravity = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
    scene.physicsWorld.contactDelegate = self

    // scene view
    sceneView = SCNView(frame: self.view.frame)
    sceneView.allowsCameraControl = true
    sceneView.showsStatistics = true
    sceneView.scene = scene
    sceneView.delegate = self
    self.view.addSubview(sceneView)

    // camera node
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
    cameraNode.camera = camera
    scene.rootNode.addChildNode(cameraNode)

    // lights
    addOmniLight(UIColor.redColor(), position:SCNVector3(x: -40, y: -40, z: -40))
    addOmniLight(UIColor.greenColor(), position:SCNVector3(x: -40, y: -40, z: -40))
    addOmniLight(UIColor.redColor(), position:SCNVector3(x: 40, y: 40, z: 40))
    addOmniLight(UIColor.greenColor(), position:SCNVector3(x: 40, y: 40, z: 40))
    addOmniLight(UIColor.blueColor(), position:SCNVector3(x: 40, y: 40, z: 40))
    addOmniLight(UIColor.blueColor(), position:SCNVector3(x: -40, y: -40, z: -40))

    // gestures
    let tapGesture = UITapGestureRecognizer(target: self, action: "singleTap:")
    tapGesture.numberOfTapsRequired = 1
    sceneView.addGestureRecognizer(tapGesture)

    let doubleTapGesture = UITapGestureRecognizer(target: self, action: "doubleTap:")
    doubleTapGesture.numberOfTapsRequired = 2
    sceneView.addGestureRecognizer(doubleTapGesture)

    // entities
    addAllSpheres()
    addAimLine()
    resetPositions()
  }

  func addOmniLight(color:UIColor, position:SCNVector3) {
    let light = SCNLight()
    light.type = SCNLightTypeOmni
    light.color = color

    let lightNode = SCNNode()
    lightNode.light = light
    lightNode.position = position

    scene.rootNode.addChildNode(lightNode)
  }

  // MARK: entities

  func addSphere(color:UIColor, radius:CGFloat, collides:Bool) -> SCNNode {
    let sphereMaterial = SCNMaterial()
    sphereMaterial.diffuse.contents = color

    let sphereGeometry = SCNSphere(radius: radius)
    sphereGeometry.materials = [sphereMaterial]

    let shape = SCNPhysicsShape(geometry: sphereGeometry, options: nil)

    let sphere = SCNNode(geometry: sphereGeometry)

    if collides {
      let sphereBody = SCNPhysicsBody(type: .Dynamic, shape: shape)
      sphereBody.categoryBitMask = sphereCategory
      sphereBody.contactTestBitMask = sphereCategory
      sphereBody.collisionBitMask = sphereCategory
      sphere.physicsBody = sphereBody
    }

    return sphere
  }

  func addAllSpheres() {
    for (var i = 0; i < numSpheres; i++) {
      let sphere = addSphere(UIColor.greenColor(), radius: 0.5, collides:true)
      self.scene.rootNode.addChildNode(sphere)
      targetSpheres.append(sphere)
    }

    mainSphere = addSphere(mainSphereOriginalColor, radius: 1.0, collides:true)
    self.scene.rootNode.addChildNode(mainSphere)

    centerSphere = addSphere(UIColor.blueColor(), radius: 0.25, collides:false)
    self.scene.rootNode.addChildNode(centerSphere)
  }

  func addAimLine() {
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.cyanColor()

    let cylinderGeometry = SCNCylinder(radius: 0.05, height: CGFloat(aimLineHeight))
    cylinderGeometry.materials = [material]

    aimLine = SCNNode(geometry: cylinderGeometry)

    self.scene.rootNode.addChildNode(aimLine)
  }

  // MARK: Gestures

  func singleTap(gestureRecognizer: UIGestureRecognizer) {
    if gestureIsMainSphere(gestureRecognizer) {
      if state == GameState.Targeting  {
        endTargetingMode()
        shootMainSphere()
      } else {
        startTargetingMode()
      }
    } else {
      endTargetingMode()
    }
  }

  func doubleTap(gestureRecognizer: UIGestureRecognizer) {
    if gestureIsMainSphere(gestureRecognizer) {
      shootMainSphere()
    }
  }

  func gestureIsMainSphere(gestureRecognizer: UIGestureRecognizer) -> Bool {
    // check what nodes are tapped
    let point = gestureRecognizer.locationInView(sceneView)
    let hitResults = sceneView.hitTest(point, options: nil)

    // check that we clicked on at least one object
    if hitResults.count > 0 {
      // retrieved the first clicked object
      let result: AnyObject! = hitResults[0]

      // shoot sphere if applicable
      if result.node == mainSphere {
        return true
      }
    }

    return false
  }

  // MARK: SCNPhysicsContactDelegate methods

  func physicsWorld(world: SCNPhysicsWorld, didUpdateContact contact: SCNPhysicsContact) {

  }

  // MARK: SCNSceneRendererDelegate methods

  func renderer(renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
    let mainSphereDistance = (mainSphere.presentationNode.position - mainSphereStartingPosition).length()

    if (state == GameState.Moving) {
      if (mainSphereDistance > 20.0) {
        resetPositions()
      }
    }
  }

  func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
    updateMainSphereAndAimLine()
  }

  // MARK: Random

  func randomFloat() -> Float {
    return Float(arc4random()) / Float(UINT32_MAX)
  }

  // MARK: Main sphere targeting

  func startTargetingMode() {
    state = GameState.Targeting

    // highlight color
    mainSphere.geometry!.firstMaterial!.diffuse.contents = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.6)

    // lock camera
  }

  func endTargetingMode() {
    state = GameState.Unselected

    // reset color
    mainSphere.geometry!.firstMaterial!.diffuse.contents = mainSphereOriginalColor

    // reset camera
  }

  // MARK: Shoot and reset spheres

  func shootMainSphere() {
    aimLine.hidden = true

    mainSphereStartingPosition = mainSphere.position

    let forceDirection = aimDirection * aimMagnitude
    let forcePosition = SCNVector3(0.0, 0.0, 0.0)
    mainSphere.physicsBody?.applyForce(forceDirection, atPosition: forcePosition, impulse: true)

    state = GameState.Moving
  }

  func resetPositions() {
    endTargetingMode()

    state = GameState.Unselected

    for (index, sphere) in targetSpheres.enumerate() {
      let x:Float = Float(index) * randomFloat() - Float(index) / Float(2.0)
      let y:Float = Float(index) * randomFloat() - Float(index) / Float(2.0)
      let z:Float = Float(index) * randomFloat() - Float(index) / Float(2.0)

      sphere.position = SCNVector3(x: x, y: y, z: z)
    }

    cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: cameraTargetingDistanceFromCenter)

    mainSphere.physicsBody?.clearAllForces()
    mainSphere.physicsBody?.velocity = SCNVector3Zero

    aimDirection = SCNVector3(x: 0.0, y: 0.0, z: -1.0).normalized()

    aimLine.hidden = false

    centerSphere.position = SCNVector3Zero
  }

  // MARK: Display methods

  func updateMainSphereAndAimLine() {
    // don't do anything if we don't have pointOfView yet
    if sceneView.pointOfView == nil {
      return
    }

    let scenePosition = sceneView.pointOfView!.position

    // main sphere
    if state == GameState.Unselected {
      // update ball to be between camera and center
      let vectorFromCenterToCamera = (scenePosition - centerSphere.presentationNode.position).normalized()
      let spherePosition = vectorFromCenterToCamera * mainSphereTargetingDistanceFromCenter
      mainSphere.position = spherePosition
      aimDirection = vectorFromCenterToCamera * -1.0
      updateAimLine()
    } else if state == GameState.Targeting {
      // update aim to be online between camera and ball
      aimDirection = (mainSphere.presentationNode.position - scenePosition).normalized()
      updateAimLine()
    }
  }

  func updateAimLine() {
    // aim line
    let aimLineOffsetVector = (aimDirection * aimLineHeight / 2.0)
    let aimLinePosition = mainSphere.presentationNode.position + aimLineOffsetVector
    aimLine.position = aimLinePosition

    let verticalVector = SCNVector3(x: 0.0, y: 1.0, z: 0.0)
    let aimLineRotationAxis = verticalVector.cross(aimDirection)
    let aimLineRotationAngle = verticalVector.angle(aimDirection)
    aimLine.rotation = SCNVector4(x:aimLineRotationAxis.x, y:aimLineRotationAxis.y, z:aimLineRotationAxis.z, w:aimLineRotationAngle)
  }

  func highlightNode(sphere:SCNNode) {
    // get its material
    let material = sphere.geometry!.firstMaterial!

    // highlight it
    SCNTransaction.begin()
    SCNTransaction.setAnimationDuration(0.5)

    // on completion - unhighlight
    SCNTransaction.setCompletionBlock {
      SCNTransaction.begin()
      SCNTransaction.setAnimationDuration(0.5)
      
      material.emission.contents = UIColor.blackColor()
      
      SCNTransaction.commit()
    }
    
    material.emission.contents = UIColor.redColor()
    
    SCNTransaction.commit()
  }

}
