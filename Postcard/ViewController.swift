//
//  ViewController.swift
//  Postcard
//
//  Created by Patrick Bellot on 8/25/17.
//  Copyright © 2017 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate {
  
  @IBOutlet weak var postcard: UIImageView!
  @IBOutlet weak var colorSelection: UICollectionView!
  
  var colors = [UIColor]()
  var image: UIImage?
  var topText = "Visit London"
  var topFontName = "Helvetica Neue"
  var topColor = UIColor.white
  var bottomText = "Home of Sherlock Holms, Paddington Bear, and James Bond"
  var bottomFontName = "Helvetica Neue"
  var bottomColor = UIColor.white
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    colorSelection.dragDelegate = self
    
    colors += [.black, .gray, .white, .orange, .red, .magenta, .purple, .blue, .cyan, .green]
    
    for i in 0...9 {
      for j in 1...10 {
        let color = UIColor(hue: CGFloat(i) / 10, saturation: CGFloat(j) / 10, brightness: 1, alpha: 1)
        colors.append(color)
      }
    }
    postcard.isUserInteractionEnabled = true
    let dropInteraction = UIDropInteraction(delegate: self)
    postcard.addInteraction(dropInteraction)
    
    renderPostcard()
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
  
  func renderPostcard() {
    
    // 1 - define the total drawing area
    let drawRect = CGRect(x: 0, y: 0, width: 3000, height: 2400)
    
    // 2 - define where to draw the top and bottom text
    let topTextRect = CGRect(x: 250, y: 200, width: 2500, height: 800)
    let bottomTextRect = CGRect(x: 250, y: 1800, width: 2500, height: 600)
    
    // 3 - create UIFont instances out of the font names, providing fallbacks on failure
    let topFont = UIFont(name: topFontName, size: 350) ?? UIFont.systemFont(ofSize: 250)
    let bottomFont = UIFont(name: bottomFontName, size: 150) ?? UIFont.systemFont(ofSize: 100)
    
    // 4 - create a centered paragraph style
    let centered = NSMutableParagraphStyle()
    centered.alignment = .center
    
    // 5 - wrap that in attributed strings with the user's colors
    let topTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: topColor, .font: topFont, .paragraphStyle: centered]
    let bottomTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: bottomColor, .font: bottomFont, .paragraphStyle: centered]
    
    // 6 - start redering at the correct size
    let renderer = UIGraphicsImageRenderer(size: drawRect.size)
    
    postcard.image = renderer.image(actions: { ctx in
      
      //fill the entire screen in gray
      UIColor.gray.set()
      ctx.fill(drawRect)
      
      // 8 - draw the user's image at the top-left corner
      image?.draw(at: CGPoint(x: 0, y: 0))
      
      // 9 - draw the top and bottom text
      topText.draw(in: topTextRect, withAttributes: topTextAttributes)
      bottomText.draw(in: bottomTextRect, withAttributes: bottomTextAttributes)
    })
    
  }
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let color = colors[indexPath.item]
    let provider = NSItemProvider(object: color)
    let item = UIDragItem(itemProvider: provider)
    
    return [item]
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
    return UIDropProposal(operation: .copy)
  }
  
  func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
    let location = session.location(in: postcard)
    
    if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
      
      //handle strings
      session.loadObjects(ofClass: NSString.self) { items in
        guard let string = items.first as? String else { return }
        
        if location.y < self.postcard.bounds.midY {
          self.topFontName = string
        } else {
          self.bottomFontName = string
        }
        self.renderPostcard()
      }
    
    } else {
      
      //handle colors
      session.loadObjects(ofClass: UIColor.self) { items in
        guard let color = items.first as? UIColor else { return }
        
        if location.y < self.postcard.bounds.midY {
          self.topColor = color
        } else {
          self.bottomColor = color
        }
        self.renderPostcard()
      }
    }
    
  }
  
  @IBAction func changeText(_ sender: UITapGestureRecognizer) {
    
    // 1 - Find where the usser tapped
    let location = sender.location(in: postcard)
    
    // 2 - decide whether they want to edit the top or bottom label
    let changeTop: Bool
    
    if location.y < postcard.bounds.midY {
      changeTop = true
    } else {
      changeTop = false
    }
    
    // 3 - create an alert controller with a text field
    let ac = UIAlertController(title: "Change Text", message: nil, preferredStyle: .alert)
    
    ac.addTextField { textField in
      textField.placeholder = "Write what you want to say"
      
      if changeTop {
        textField.text = self.topText
      } else {
        textField.text = self.bottomText
      }
    }
    
    // 4 - add a "Change" button
    ac.addAction(UIAlertAction(title: "Change", style: .default) { _ in
      guard let text = ac.textFields?[0].text else { return }
      
      if changeTop {
        self.topText = text
      } else {
        self.bottomText = text
      }
      self.renderPostcard()
    })
    // 5 - add a cancel button
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    // 6 - show the alert
    present(ac, animated: true)
  }
  
  
  
  
  
  
  
  
  
}//end of class

