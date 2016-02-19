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

  let games:[String] = [
    "3D Marbles",
    "Stack Game",
    "Swing",
    "Paper Airplane",
    "Traffic"
  ]

  let demos:[String] = [
    "Fields Demo"
  ]

  func spriteKitSceneForKey(name:String) -> SKScene? {
    switch name {
    case "Swing":
      return SwingScene(size: self.view.frame.size)
    case "Stack Game":
      return StackScene(size: self.view.frame.size)
    case "Paper Airplane":
      return PaperAirplaneScene(size: self.view.frame.size)
    case "Fields Demo":
      return FieldsDemoScene(size: self.view.frame.size)
    case "Traffic":
      return TrafficScene(size: self.view.frame.size)
    default:
      return nil
    }
  }

  func controllerForKey(name:String) -> UIViewController? {
    switch name {
    case "3D Marbles":
      return ThreeDMarblesViewController()
    default:
      return nil
    }
  }

  func titleForIndexPathSection(section:Int) -> String {
    if section == 0 {
      return "Games"
    } else {
      return "Tech Demos"
    }
  }

  func keysForIndexPathSection(section:Int) -> [String] {
    if section == 0 {
      return games
    } else {
      return demos
    }
  }

  func keyNameForIndexPath(indexPath:NSIndexPath) -> String {
    return keysForIndexPathSection(indexPath.section)[indexPath.row]
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
    let tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.frame = self.view.frame
    self.view.addSubview(tableView)

    tableView.reloadData()
  }

  // MARK: UITableViewDataSource, UITableViewDelegate methods

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }

  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return titleForIndexPathSection(section)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return keysForIndexPathSection(section).count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellIdentifier")
    }
    cell!.textLabel?.text = keyNameForIndexPath(indexPath)
    return cell!
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let keyName = keyNameForIndexPath(indexPath)

    if let scene = spriteKitSceneForKey(keyName) {
      let controller = SpriteKitSceneViewController(scene: scene)
      self.navigationController?.pushViewController(controller, animated: true)
    } else if let controller = controllerForKey(keyName) {
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }

}

