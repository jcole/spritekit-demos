//
//  ListViewController.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  // MARK: Config demos

  let demos:[String] = [
    "3D Marbles",
    "Stack Game",
    "Swing"
  ]

  func spriteKitSceneForDemo(demoName:String) -> SKScene? {
    switch demoName {
    case "Swing":
      return SwingScene(size: self.view.frame.size)
    case "Stack Game":
      return StackScene(size: self.view.frame.size)
    default:
      return nil
    }
  }

  func controllerForDemo(demoName:String) -> UIViewController? {
    switch demoName {
    case "3D Marbles":
      return ThreeDMarblesViewController()
    default:
      return nil
    }
  }

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    setup()
  }

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override func viewWillDisappear(animated: Bool) {
   // self.navigationController?.setNavigationBarHidden(true, animated: false)
  }

  func setup() {
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.frame = self.view.frame
    self.view.addSubview(tableView)

    tableView.reloadData()
  }

  // MARK: UITableViewDataSource, UITableViewDelegate methods

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return demos.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellIdentifier")
    }
    cell!.textLabel?.text = demos[indexPath.row]
    return cell!
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let demoName = demos[indexPath.row]

    if let scene = spriteKitSceneForDemo(demoName) {
      let controller = SpriteKitSceneViewController(scene: scene)
      self.navigationController?.pushViewController(controller, animated: true)
    } else if let controller = controllerForDemo(demoName) {
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }

}

