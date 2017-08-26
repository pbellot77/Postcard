//
//  FontsViewController.swift
//  Postcard
//
//  Created by Patrick Bellot on 8/25/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import MobileCoreServices

class FontsViewController: UITableViewController, UITableViewDragDelegate {
  
  let fonts = UIFont.familyNames.sorted()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    title = "Fonts"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fonts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let fontName = fonts[indexPath.row]
    
    cell.textLabel?.text = fontName
    cell.textLabel?.font = UIFont(name: fontName, size: 18)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let string = fonts[indexPath.row]
    guard let data = string.data(using: .utf8) else { return [] }
    let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
    return [UIDragItem(itemProvider: itemProvider)]
  }
  
}
