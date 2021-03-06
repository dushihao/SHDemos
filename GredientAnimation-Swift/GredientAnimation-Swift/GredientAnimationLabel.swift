//
//  GredientAnimationLabel.swift
//  GredientAnimation-Swift
//
//  Created by shihao on 2017/9/1.
//  Copyright © 2017年 shihao. All rights reserved.
//

import UIKit

@IBDesignable
class GredientAnimationLabel: UIView {

    // MARK: - Types
    
    struct Constans {
        struct Font {
            static let loadingName = "HelveticaNeue-UltraLight"
        }
    }
    
    // MARK: - Properties
    
    let gradientLayer : CAGradientLayer = {
       
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.red.cgColor,UIColor.black.cgColor,UIColor.red.cgColor];
        gradientLayer.startPoint = CGPoint (x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint (x: 1.0, y: 0.5)
        let locations = [0.25,0.5,0.75]
        gradientLayer.locations = locations as [NSNumber]
        
        return gradientLayer
    }()
    
    let textAttributes : [String: AnyObject] = {
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        return [
            NSFontAttributeName : UIFont(name: Constans.Font.loadingName, size: 70)!,
            NSParagraphStyleAttributeName: style
        ]
    }()
    
    @IBInspectable var text : String! {
        didSet{
            setNeedsDisplay()
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
            text.draw(in: bounds, withAttributes: textAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let maskLayer = CALayer()
            maskLayer.frame = bounds .offsetBy(dx: bounds.size.width, dy: 0)
            maskLayer.contents = image?.cgImage
            gradientLayer.mask = maskLayer
        }
    }
    
    // MARK: - ======Override======
    // MARK: - View life circle
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(x: -bounds.size.width, y: bounds.origin.y, width: 2*bounds.size.width, height: bounds.size.height)
    }
    
    override func didMoveToSuperview() {
         // set animation
        
        layer.addSublayer(gradientLayer)
        
        let gradientAnimation = CABasicAnimation (keyPath: "locations")
        gradientAnimation.fromValue = [0,0,0.25]
        gradientAnimation.toValue = [0.75,1.0,1.0]
        gradientAnimation.duration = 3
        gradientAnimation.repeatCount = Float.infinity
        
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
    
    
    
    // MARK: - Convince

}
