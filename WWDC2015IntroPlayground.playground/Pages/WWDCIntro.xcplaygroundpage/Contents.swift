/*:

# WWDC 2015 - Attempt to Replicate

If you want to add to your project, copy the ContainerView class and Utilities into your project
*/

/*: A loop to print each character on a seperate line

container = ContainerView(frame: view.bounds)

view.addSubview(container)

*/

import UIKit
import XCPlayground
import QuartzCore

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
    let screenWidth = bounds.width
    
    //: # Base Duration, alot of function use a percentage of it for its duration
    let baseDuration : NSTimeInterval = 8
    
    /// 1 - Big Pink Diamond
    var shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 40, 40), color: UIColor(rgba: "#FBDEFE"))
    animation(shape, groupDuration : baseDuration, groupDelay : 0.0, translateOffset : screenWidth * 0.5, translateDelay : 1.2, zoomToSize : 10, zoomDuration : baseDuration, alphaDuration : baseDuration)
    
    /// 2 - Smaller Pink Diamond
    shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 22, 22), color: UIColor(rgba: "#F297C0").colorWithAlphaComponent(0.8))
    animation(shape, groupDuration : baseDuration, groupDelay : 0.2, translateOffset : screenWidth * 0.75, translateDelay : 1.0, zoomToSize : 10, zoomDuration : baseDuration, alphaDuration : baseDuration)
    
    /// 3 - Big Circles
    shape = CAShapeLayer.circleShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 40, 40), color: UIColor(rgba: "#CEFFFE").colorWithAlphaComponent(0.7))
    shape.transform = CATransform3DMakeTranslation(0, -20, 0) // tighten it
    animation(shape, groupDuration : baseDuration, groupDelay : 1.4, translateOffset : screenWidth * 0.45, translateDelay : 1.4, zoomToSize : 22, zoomDuration : baseDuration * 0.7, alphaDuration : baseDuration)
    
    /// 4 - Horizontal Blue Diamonds
    shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 40, 40), color: UIColor(rgba: "#6934F2").colorWithAlphaComponent(0.5))
    shape.transform = CATransform3DMakeTranslation(0, -20, 0) // tighten it
    animation(shape, groupDuration : baseDuration, groupDelay : 0.5, translateOffset : screenWidth * 0.25, translateDelay : 2.0, zoomToSize : 10, zoomDuration : baseDuration * 1.1, alphaDuration : baseDuration, instances : 2, replicatorRotation: 0, replicatorInstanceRotation: CGFloat(M_PI))
    
    /// 5 - Vertical Blue Diamonds
    shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 40, 40), color: UIColor(rgba: "#6934F2").colorWithAlphaComponent(0.5))
    shape.transform = CATransform3DMakeTranslation(0, -20, 0) // tighten it
    animation(shape, groupDuration : baseDuration, groupDelay : 0.3, translateOffset : screenWidth * 0.25, translateDelay : 2.0, zoomToSize : 10, zoomDuration : baseDuration * 1.1, alphaDuration : baseDuration, instances : 2, replicatorRotation: CGFloat(M_PI_2), replicatorInstanceRotation: CGFloat(M_PI))
    
    /// 6 - Inner Pink Follow Diamon
    shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 22, 22), color: UIColor(rgba: "#D16DDE").colorWithAlphaComponent(0.9))
    animation(shape, groupDuration : baseDuration, groupDelay : 0.5, translateOffset : screenWidth * 0.75, translateDelay : 1.0, zoomToSize : 10, zoomDuration : baseDuration, alphaDuration : baseDuration)
    
    /// 7 - Inner Pink Small Follow Diamon
    shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 12, 12), color: UIColor(rgba: "#E662CA").colorWithAlphaComponent(0.5))
    animation(shape, groupDuration : baseDuration, groupDelay : 0.2, translateOffset : screenWidth * 0.85, translateDelay : 1.0, zoomToSize : 10, zoomDuration : baseDuration, alphaDuration : baseDuration)
    
    /// 8 - Green Circles
    shape = CAShapeLayer.circleShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 40, 40), color: UIColor(rgba: "#E5FDB5").colorWithAlphaComponent(0.7))
    shape.transform = CATransform3DMakeTranslation(0, -20, 0) // tighten it
    animation(shape, groupDuration : baseDuration, groupDelay : 2.8, translateOffset : screenWidth * 0.65, translateDelay : 1.4, zoomToSize : 8, zoomDuration : baseDuration * 0.7, alphaDuration : baseDuration)
    
    /// 9 - Green Diamond
    shape = CAShapeLayer.diamondShapeWithSize(CGRectMake(bounds.midX, bounds.midY, 40, 40), color: UIColor(rgba: "#63E9D3").colorWithAlphaComponent(0.6))
    animation(shape, groupDuration : baseDuration, groupDelay : 2.8, translateOffset : screenWidth * 0.75, translateDelay : 1.5, zoomToSize : 12, zoomDuration : baseDuration, alphaDuration : baseDuration)
    
    apple.center = CGPointMake(frame.midX, frame.midY)
    apple.contentMode = .Center
    addSubview(apple)
  }
  
  
  
/*:
  
  # Le Godzilla Function
  
  Function that will use all the values given to perform animations.
  
  We are essentially doing:
  
  * Creating a Zoom Animation, FadeOut, Move Away Animation
  * Here we generate the replicator layer
  * We can pass in rotation for the Instances the Replicator will Generate .instanceTransform
  * A couple of occasions we have to tweak its own rotation so we pass in replicatorRotation
  
  There are alof of delays and durations for each animation, we do this because sometimes we get a zoom for a bit then it takes a while for the shapes to animate out.
  
  We are also calculating the max time it will take and tweaking each duration accordingly. Nice little map / reduce swift function
  
  We are using kCAMediaTimingFunctionEaseIn for its timing, but you can play around with different ones
  
  */
  func animation(shape : CAShapeLayer
    , groupDuration : NSTimeInterval
    , groupDelay : NSTimeInterval
    , translateOffset : CGFloat
    , translateDelay : NSTimeInterval
    , zoomToSize : CGFloat
    , zoomDuration : NSTimeInterval
    , alphaDuration : NSTimeInterval
    , instances : Int = 4
    , replicatorRotation : CGFloat = 0
    , replicatorInstanceRotation : CGFloat = CGFloat(M_PI_2)
    )
  {
    
    /// create replicator as big as the view, and passing in the current shape to be replicated
    let replicator = CAReplicatorLayer.replicatorLayer(shape, bounds: bounds, instancesCount : instances)
    
    replicator.instanceTransform = CATransform3DMakeRotation(replicatorInstanceRotation, 0, 0, 1)
    replicator.transform = CATransform3DMakeRotation(replicatorRotation, 0, 0, 1)
    
    
    /// add to superview
    layer.addSublayer(replicator)
    
    
    /// start generating animations
    
    let duration = groupDuration
    
    /// zoom, move away, and opacity animations
    let zoomAnimation = CABasicAnimation.zoom(shape, start : 0.01, finish: zoomToSize, duration: zoomDuration, beginOffset: 0.0)
    let moveAway = CABasicAnimation.moveAway(shape, duration : duration, beginOffset: translateDelay, moveAwayOffset : translateOffset)
    let opacity = CABasicAnimation.fadeOut(shape, duration : alphaDuration, beginOffset: 0.0)
    
    
    /// keep reference of animatiosn in an array
    let animations : [CABasicAnimation] = [zoomAnimation,moveAway,opacity]
    
    
    /// add all begin times, as we need to send this to our animation group to increase animation duration
    
    let beginTimes: [CFTimeInterval] = animations.map { return $0.beginTime } /// return array of begin times
    let maxTime   = beginTimes.reduce(0) { return max($0, $1) } /// reduce to the max value
    let totalGroupDuration = duration + maxTime /// set the final animation duration
    
    
    /// generate the group animation, adding the array of animations
    
    let group = CAAnimationGroup()
    group.beginTime = CACurrentMediaTime() + CFTimeInterval(groupDelay)
    group.duration = totalGroupDuration + groupDelay
    group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    group.animations = animations
    group.removedOnCompletion = false
    group.fillMode = kCAFillModeForwards
    
    /// kick off animation
    shape.addAnimation(group, forKey: "")
    
  }
  
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


let containerView = ContainerView(frame: CGRectMake(0, 0, 640, 320))
containerView.backgroundColor = UIColor.whiteColor()
XCPShowView("Container View", view: containerView)
