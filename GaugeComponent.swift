//
//  GaugeComponent.swift
//  honeygrow
//
//  Created by Jorge Paiz on 1/6/16.
//  Copyright © 2016 Andres Garcia Figueroa. All rights reserved.
//



import UIKit



@IBDesignable class GaugeComponent: UIView {
  
  // MARK: Properties
  @IBInspectable var borderColor:UIColor  = UIColor.clearColor() {
    didSet {
      layer.borderColor = borderColor.CGColor
    }
  }
  
  @IBInspectable var borderWidth:CGFloat  = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable var cornerRadius:CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable var bigNumber:Int = 0 {
    didSet {
      bigNumberLabel.text = String(bigNumber)
    }
  }
  
  @IBInspectable var units:String = "" {
    didSet {
      unitsLabel.text = units
    }
  }
  
  @IBInspectable var minValue:Int = 0 {
    didSet {
      minValueLabel.text = String(minValue)
    }
  }
  
  @IBInspectable var maxValue:Int = 0 {
    didSet {
      maxValueLabel.text = String(maxValue)
    }
  }
  
  @IBInspectable var bigNumberColor:UIColor = UIColor.redColor() {
    didSet {
      bigNumberLabel.textColor = bigNumberColor
    }
  }
  
  @IBInspectable var unitsColor:UIColor = UIColor.redColor() {
    didSet {
      unitsLabel.textColor = unitsColor
    }
  }
  
  @IBInspectable var scopeColor:UIColor = UIColor.redColor() {
    didSet {
      minValueLabel.textColor = scopeColor
      maxValueLabel.textColor = scopeColor
    }
  }
  
  @IBInspectable var bigFontFamily:String = "Arial" {
    didSet {
      bigNumberLabel.font = UIFont(name: bigFontFamily, size: bigFontSize)
    }
  }
  
  @IBInspectable var bigFontSize:CGFloat = 60 {
    didSet {
      bigNumberLabel.font = UIFont(name: bigFontFamily, size: bigFontSize)
    }
  }
  
  @IBInspectable var unitsFontFamily:String = "Arial" {
    didSet {
      unitsLabel.font = UIFont(name: unitsFontFamily, size: unitsFontSize)
    }
  }
  
  @IBInspectable var unitsFontSize:CGFloat = 32 {
    didSet {
      unitsLabel.font = UIFont(name: unitsFontFamily, size: unitsFontSize)
    }
  }
  
  var lineWithForValues:Int = 15
  
  
  
  // MARK: Private values
  private let bigNumberLabel:UILabel  = UILabel()
  private let unitsLabel:UILabel      = UILabel()
  private let minValueLabel:UILabel   = UILabel()
  private let maxValueLabel:UILabel   = UILabel()
  private var baseArc:UIBezierPath    = UIBezierPath()
  private let arcAngle                = 120.0
  private var radius:CGFloat           = 0.0
  private var centerArc:CGPoint       = CGPoint()
  private let padding:CGFloat         = 10.0
  private let animationDuration       = 0.8
  private let baseArcLineWitdh        = 5
  
  
  
  
  // MARK: functions
  override func drawRect(rect: CGRect) {
    let positionY = bounds.height/3
    let widthComp = bounds.width
    let minMaxPaddingHorz:CGFloat   = 25
    let minMaxPaddingBottom:CGFloat = CGRectGetHeight(bounds) - 30
    
    // big number label
    bigNumberLabel.frame = CGRect(x: 0, y: positionY, width: widthComp, height: 50)
    bigNumberLabel.textAlignment = .Center
    addSubview(bigNumberLabel)
    
    // units label
    unitsLabel.frame = CGRect(x: 0, y: positionY + CGRectGetHeight(bigNumberLabel.frame), width: widthComp, height: 30)
    unitsLabel.textAlignment = .Center
    addSubview(unitsLabel)
    
    // min value label
    minValueLabel.frame = CGRect(x: minMaxPaddingHorz, y: minMaxPaddingBottom, width: widthComp - minMaxPaddingHorz * 2, height: 30)
    minValueLabel.textAlignment = .Left
    addSubview(minValueLabel)
    
    // max value label
    maxValueLabel.frame = CGRect(x: minMaxPaddingHorz, y: minMaxPaddingBottom, width: widthComp - minMaxPaddingHorz * 2, height: 30)
    maxValueLabel.textAlignment = .Right
    addSubview(maxValueLabel)
    
    radius = max(bounds.width, bounds.height) / 2
    centerArc = CGPoint(x: radius, y: radius)
    let startAngle:Double = 90 + arcAngle / 2
    let endAngle:Double   = 90 - arcAngle / 2
    baseArc = UIBezierPath(arcCenter: centerArc, radius: radius - padding, startAngle:CGFloat(startAngle * M_PI / 180), endAngle:CGFloat(endAngle * M_PI / 180), clockwise: true)
    baseArc.lineCapStyle = .Round
    UIColor.lightGrayColor().setStroke()
    baseArc.lineWidth = CGFloat(baseArcLineWitdh)
    baseArc.stroke()
  }
  
  func showValueWithParams(values values:[Int], valuesColor:[UIColor], minValue:Int, maxValue:Int) {
    self.minValue = minValue
    self.maxValue = maxValue
    showValuesWithAnimation(values: values, valuesColor: valuesColor)
  }
  
  func showValuesWithAnimation(values values:[Int], valuesColor:[UIColor]) {
    radius = max(bounds.width, bounds.height) / 2
    centerArc = CGPoint(x: radius, y: radius)
    let startAngle:Double = 90 + arcAngle / 2
    var lastEndAngle:Double = startAngle
    var totalValue:Int = 0
    
    
    // animation of arcs
    for (index, value) in values.enumerate() {
      totalValue += value
      var track:Double = (360.0 - arcAngle) * Double(value) / Double(maxValue - minValue)
      track += lastEndAngle
      let arc = UIBezierPath(arcCenter: centerArc, radius: radius - padding, startAngle: CGFloat(startAngle * M_PI / 180), endAngle: CGFloat(track * M_PI / 180), clockwise: true)
      lastEndAngle = track
      
      let progressArc = CAShapeLayer()
      progressArc.path = arc.CGPath
      progressArc.strokeColor = valuesColor[index].CGColor
      progressArc.fillColor = UIColor.clearColor().CGColor
      progressArc.lineWidth = CGFloat(lineWithForValues)
      progressArc.lineCap = kCALineCapRound
      
      let position = layer.sublayers?.count ?? 0
      layer.insertSublayer(progressArc, atIndex: UInt32(position - index))
      
      let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
      animateStrokeEnd.duration   = animationDuration
      animateStrokeEnd.fromValue  = 0
      animateStrokeEnd.toValue    = 1.0
      
      progressArc.addAnimation(animateStrokeEnd, forKey: "animate stroke and animation")
    }
    
    // total animation
    bigNumberLabel.text = String(totalValue + minValue)
    
  }
  
  
}
