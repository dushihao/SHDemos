//
//  Progress.swift
//  ProgressAnimation-Swift
//
//  Created by shihao on 2017/8/31.
//  Copyright © 2017年 shihao. All rights reserved.
//

import UIKit

@IBDesignable
class Progress: UIView {

    // MARK: - type 
    struct Constans {
        struct Colors {
            static let teal = UIColor (red: 0.27, green: 0.80, blue: 0.80, alpha: 1)
            static let orange = UIColor (red: 0.90, green: 0.59, blue: 0.20, alpha: 1)
            static let pink = UIColor (red: 0.90, green: 0.12, blue: 0.45, alpha: 1)
        }
    }
    
    // MARK: - properties
    let progressLayer = CAShapeLayer()
    let gradientLayer = CAGradientLayer()
    
    var range: CGFloat = 128
    var curValue: CGFloat = 0 {
        didSet{
            animationStroke()
        }
    }
    
    // MARK: - override
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayer()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupLayer()
    }
    
    override func layoutSubviews() {
       // setupLayer()
    }
    
    // MARK: - convince
    
    func setupLayer() {
        //progresslayer
        progressLayer.position = CGPoint.zero
        progressLayer.lineWidth = 3
       // progressLayer.strokeStart = 0 // deault is 0.0
        progressLayer.strokeEnd = 0
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.red.cgColor
        
        let arcCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let radius = CGFloat(self.bounds.size.width)/2 - progressLayer.lineWidth
        let startAngle = CGFloat(-Double.pi/2)
        let endAngle = CGFloat(3*Double.pi/2)
        let progressPath = UIBezierPath (arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        progressLayer.path = progressPath.cgPath
        
        //gradientLayer
        gradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height)
        // 没有写 cgColor 结果找了俩小时 才找到自己给自己挖的坑 (╯﹏╰)
        gradientLayer.colors = [
            Constans.Colors.teal.cgColor,
            Constans.Colors.orange.cgColor,
            Constans.Colors.pink.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x:0.5,y:0)
        gradientLayer.endPoint = CGPoint(x:0.5,y:1)
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
        //layer.addSublayer(progressLayer)
    }
    
    func animationStroke() {
        
        let animation = CABasicAnimation (keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = curValue / range
        progressLayer.add(animation, forKey: "animation1")
        // animation finished , update progressLayer.strokeEnd
        progressLayer.strokeEnd = curValue/range
    }

}
