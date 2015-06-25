import Foundation
import UIKit
import QuartzCore

extension UIColor {
    public convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", appendNewline: false)
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", appendNewline: false)
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

extension UIBezierPath
{
   public static func diamondShapeWithSize(size : CGSize, cornerRadius : CGFloat = 8) -> CGPathRef
    {
        let roundedSquare = UIBezierPath(roundedRect: CGRectMake(0, 0, size.width, size.height), cornerRadius: CGFloat(size.width * 0.25))
        
        // lets rotate it
        
        roundedSquare.applyTransform(CGAffineTransformMakeRotation(CGFloat(M_PI_4)))
        
        return roundedSquare.CGPath
    }
    
    public static func circleShapeWithSize(size : CGSize) -> CGPathRef
    {
        let circle = UIBezierPath(ovalInRect: CGRectMake(0, 0, size.width, size.height))
        return circle.CGPath
    }
}

extension CAShapeLayer
{
    
    // TODO : Can Refactor
    public static func diamondShapeWithSize(frame : CGRect, color : UIColor, cornerRadius : CGFloat = 8) -> CAShapeLayer
    {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath.diamondShapeWithSize(frame.size)
        shape.position = frame.origin
        shape.fillColor = color.CGColor
        applyShadow(shape)
        return shape
    }
    
    public static func circleShapeWithSize(frame : CGRect, color : UIColor) -> CAShapeLayer
    {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath.circleShapeWithSize(frame.size)
        shape.position = frame.origin
        shape.fillColor = color.CGColor
        applyShadow(shape)
        return shape
    }
    
    public static func applyShadow(shape : CAShapeLayer)
    {
        let color = UIColor(CGColor: shape.fillColor!)
        shape.shadowColor = color.colorWithAlphaComponent(0.9).CGColor
        shape.shadowOffset = CGSizeMake(1, 2)
        shape.shadowRadius = 2
        shape.shadowOpacity = 0.4
        shape.rasterizationScale = UIScreen.mainScreen().scale
        shape.shouldRasterize = true
    }
}

extension CAReplicatorLayer
{
    
  public static func replicatorLayer(shape : CALayer, bounds : CGRect, instancesCount : Int = 4) -> CAReplicatorLayer
    {
        let replicator = CAReplicatorLayer()
        replicator.frame = bounds
        replicator.preservesDepth = true
        replicator.instanceCount = instancesCount
        replicator.instanceTransform = CATransform3DTranslate(CATransform3DMakeRotation(CGFloat(M_PI_2), 0, 0, 1), 0, 6, 0)
        replicator.addSublayer(shape)
        return replicator
    }
}

extension CAAnimationGroup
{
    public static func shapeAnimation(layer : CALayer, moveAwayOffset : CGFloat, beginOffset : NSTimeInterval = 0.0) -> CAAnimationGroup
    {
        let animationDuration : NSTimeInterval = 10.0
        
        let zoomAnimation = CABasicAnimation.zoom(layer, start : 0.1, finish: 24, duration: animationDuration, beginOffset: 0)
        let opacity = CABasicAnimation.fadeOut(layer, duration : animationDuration, beginOffset: 1.0)
        let moveAway = CABasicAnimation.moveAway(layer, duration : animationDuration, beginOffset: 2.0, moveAwayOffset : moveAwayOffset)
        
        
        let group = CAAnimationGroup()
        group.beginTime = beginOffset
        group.duration = animationDuration
        group.animations = [zoomAnimation, opacity, moveAway]
        group.removedOnCompletion = false
        group.fillMode = kCAFillModeBackwards
        
        return group
    }
}

extension CABasicAnimation
{
    public static func zoom(layer : CALayer, start : CGFloat, finish : CGFloat, duration : NSTimeInterval, beginOffset : NSTimeInterval) -> CABasicAnimation
    {
        var layerTransform : CATransform3D = layer.transform
        layerTransform = CATransform3DScale(layerTransform, 0.1, 0.1, 1.0)
        layer.transform = layerTransform
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(finish, finish, 1))
        animation.beginTime = beginOffset
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeBackwards
        animation.autoreverses = false
        return animation
    }
    
    public static func fadeOut(layer : CALayer, duration : NSTimeInterval, beginOffset : NSTimeInterval) -> CABasicAnimation
    {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.toValue = 0.0
        animation.beginTime = beginOffset
        animation.duration = duration
        animation.removedOnCompletion = false
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
    
    public static func moveAway(layer : CALayer, duration : NSTimeInterval, beginOffset : NSTimeInterval, moveAwayOffset : CGFloat) -> CABasicAnimation
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = NSValue(CGPoint: CGPointApplyAffineTransform(layer.position, CGAffineTransformMakeTranslation(0, moveAwayOffset)))
        animation.beginTime = beginOffset
        animation.duration = duration
        animation.autoreverses = false
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        return animation
    }
}

// try and have a go at blending modes
//https://github.com/rbreve/iOS-Image-Filters/blob/master/PhotoFilters/UIImage%2BFilters.m
/*
CIImage *inputImage = [[CIImage alloc] initWithImage:self];

//try with different textures
CIImage *bgCIImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:imageName]];


CIContext *context = [CIContext contextWithOptions:nil];

CIFilter *filter= [CIFilter filterWithName:blendMode];


// inputBackgroundImage most be the same size as the inputImage

[filter setValue:inputImage forKey:@"inputBackgroundImage"];
[filter setValue:bgCIImage forKey:@"inputImage"];

return [self imageFromContext:context withFilter:filter];
*/
