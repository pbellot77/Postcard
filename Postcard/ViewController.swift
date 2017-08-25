//
//  ViewController.swift
//  Postcard
//
//  Created by Patrick Bellot on 8/25/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var colors = [UIColor]()
  
  @IBOutlet weak var postcard: UIImageView!
  @IBOutlet weak var colorSelection: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    colors += [.black, .gray, .white, .orange, .red, .magenta, .purple, .blue, .cyan, .green]
    
    for i in 0...9 {
      for j in 1...10 {
        let color = UIColor(hue: CGFloat(i) / 10, saturation: CGFloat(j) / 10, brightness: 1, alpha: 1)
        colors.append(color)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
    cell.backgroundColor = colors[indexPath.row]
    cell.layer.borderWidth = 1
    cell.layer.cornerRadius = 5
    
    return cell
  }
  
  
}//end of class

