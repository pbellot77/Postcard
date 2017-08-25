//
//  FontsViewController.swift
//  Postcard
//
//  Created by Patrick Bellot on 8/25/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class FontsViewController: UITableViewController {
  
  let fonts = UIFont.familyNames.sorted()
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
  
}
