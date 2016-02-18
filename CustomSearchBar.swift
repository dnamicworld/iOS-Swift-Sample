//
//  CustomSearchBar.swift
//  honeygrow
//
//  Created by Jorge Paiz on 1/27/16.
//  Copyright © 2016 Andres Garcia Figueroa. All rights reserved.
//



import UIKit



class CustomSearchBar: UISearchBar {
  
  
  
  // MARK: - Public Properties
  
  
  
  // MARK: - Private Properties
  private var customFont: UIFont!
  private var customTextColor: UIColor!
  private var boxLineWidth: CGFloat     = 1.0
  private var boxPaddingWidht: CGFloat  = 18.0
  private var boxPaddingHeight: CGFloat = 12.0
  
  
  
  // MARK: - Lifecycle of component
  override func drawRect(rect: CGRect) {
    
    // find the index of the search field in the search bar subviews
    if let index = indexOfSearchFieldInSubviews() {
      // access the serarch field
      let searchField   = subviews[0].subviews[index] as! UITextField
      
      // set its frame
      searchField.bounds = CGRect(x: 20.0, y: 0.0, width: 120.0, height: frame.size.height)
      
      // set the font and color text of the search field
      searchField.font                = customFont
      searchField.textColor           = customTextColor
      
      // set background color of the search textfield
      searchField.backgroundColor = barTintColor
      searchField.leftViewMode    = UITextFieldViewMode.Always
      
      // draw line of the bottom edge
      let startPoint = CGPoint(x: boxPaddingWidht, y: boxPaddingHeight)
      let boxBounds  = CGSize(width: frame.width - boxPaddingWidht * 2, height: frame.height - boxPaddingHeight * 2)
      let box        = UIBezierPath(rect: CGRect(origin: startPoint, size: boxBounds))
      
      // add the shape to layer
      let shapeLayer          = CAShapeLayer()
      shapeLayer.path         = box.CGPath
      shapeLayer.strokeColor  = customTextColor.CGColor
      shapeLayer.lineWidth    = boxLineWidth
      shapeLayer.fillColor    = UIColor.clearColor().CGColor
      layer.addSublayer(shapeLayer)
    }
    
    super.drawRect(rect)
  }
  
  
  
  // MAKR: - Initialization
  init(frame: CGRect, font: UIFont, textColor: UIColor) {
    super.init(frame: frame)
    
    self.frame      = frame
    customFont      = font
    customTextColor = textColor
    searchBarStyle  = UISearchBarStyle.Prominent
    translucent     = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  
  // MARK: - Public Mehtods
  
  
  
  // MARK: - Private Methods
  private func indexOfSearchFieldInSubviews() -> Int! {
    var indexResult:Int!
    let searchBarView = subviews[0]
    
    for (index, element) in searchBarView.subviews.enumerate() {
      if element.isKindOfClass(UITextField) {
        indexResult = index
        break
      }
    }
    
    return indexResult
  }
}
