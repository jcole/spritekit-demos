//
//  ViewController.swift
//  Jeff Game Demos
//
//  Created by Jeff Cole on 2/15/16.
//  Copyright © 2016 Jeff Cole. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  // subviews
  var tableView = UITableView()

  // constants
  let demos:[String:UIViewController.Type] = [
    "3d Marbles": ThreeDMarblesViewController.self,
    "Stack Game": StackGameViewController.self,
    "Swing": SwingViewController.self
  ]

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
    cell!.textLabel?.text = demos.keys.sort()[indexPath.row]
    return cell!
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let key = demos.keys.sort()[indexPath.row]
    if let controllerClass = demos[key] {
      let controller = controllerClass.init()
      self.navigationController?.pushViewController(controller, animated: true)
    }
  }
}

