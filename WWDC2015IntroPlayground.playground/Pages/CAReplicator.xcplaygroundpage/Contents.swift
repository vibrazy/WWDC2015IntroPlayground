//: [Previous](@previous)

import Foundation
import UIKit
import XCPlayground

//: Container View - This is a Proxy view that will render the animation
class ContainerView : UIView
{
  let apple : UIImageView = UIImageView(image: UIImage(named: "apple"))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAnimation()
  }
  
  func setupAnimation()
  {
    // create shape
    var shape = CAShapeLayer()
    shape.path = UIBezierPath(ovalInRect: CGRectMake(-15, -15, 80, 80)).CGPath
    shape.fillColor = UIColor.blueColor().CGColor
    shape.position = layer.position
    layer.addSublayer(shape)
    
    shape = CAShapeLayer()
    shape.position = layer.position
    layer.addSublayer(shape)
    
    shape.contents = apple.image?.CGImage
    shape.bounds = apple.bounds
    
  }


  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

let containerView = ContainerView(frame: CGRectMake(0, 0, 320, 320))
containerView.backgroundColor = UIColor.redColor()
XCPShowView("Container View", view: containerView)

//: [Next](@next)
