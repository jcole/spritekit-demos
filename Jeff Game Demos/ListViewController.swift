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

  // MARK: Setup demos
  
  let items = [
    ["Games", [
      "Build a House",
      ]],

    ["Demos", [
      "3D Marbles",
      "Fields",
      "Paper Airplane",
      "Swinging",
      "Traffic"
    ]]
  ]

  func demoForKey(name:String) -> AnyObject? {
    switch name {
    case "Swinging":
      return SwingScene(fileNamed: "SwingScene")
    case "Build a House":
      return StackScene(fileNamed: "StackScene")
    case "Paper Airplane":
      return PaperAirplaneScene(fileNamed: "PaperAirplaneScene")
    case "Fields":
      return FieldsDemoScene(size: self.view.frame.size)
    case "Traffic":
      return TrafficScene(size: self.view.frame.size)
    case "3D Marbles":
      return ThreeDMarblesViewController()
    default:
      return nil
    }
  }

  func sectionName(section:Int) -> String {
    return items[section][0] as! String
  }

  func demoName(indexPath:NSIndexPath) -> String {
    return (items[indexPath.section][1] as! [String])[indexPath.row]
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
    return items.count
  }

  func titleForIndexPathSection(section:Int) -> String {
    return sectionName(section)
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return titleForIndexPathSection(section)
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items[section][1].count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier")
    if cell == nil {
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellIdentifier")
    }
    
    cell!.textLabel?.text = demoName(indexPath)
    return cell!
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let keyName = demoName(indexPath)
    
    if let scene = demoForKey(keyName) as? SKScene {
      let controller = SpriteKitSceneViewController(scene: scene)
      self.navigationController?.pushViewController(controller, animated: true)
    } else if let controller = demoForKey(keyName) as? UIViewController {
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }

}

