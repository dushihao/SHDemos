//
//  FadingLabel.swift
//  SecretTextAnimation-swift
//
//  Created by shihao on 2017/9/6.
//
//

import UIKit

class FadingLabel: CharacterLabel {

    // MARK: - properties
    override var attributedText: NSAttributedString?{
        get{
            return super.attributedText
        }
        set{
            super.attributedText = newValue
            self.animationIn { (finished) in
                self.animationIn(nil)
            }
        }
    }
    
    override func initialTextLayerAttributes(_ textLayer: CATextLayer) {
        textLayer.opacity = 0
    }
 
    // MARK: - convience
    
    func animationIn(_ completion:((_ finished:Bool) -> Void)?) {
        
        for textLayer in characterTextLayer {
            let duration = (TimeInterval(arc4random() % 100) / 200.0) + 0.25
            let delay = TimeInterval(arc4random() % 100) / 500.0
            
            CLMLayerAnimation.animation(textLayer, duration: duration, delay: delay, animations: {
                textLayer.opacity = 1
            }, completion: nil)
        }
    }
    
    func animatinOut(_ completion:((_ finished: Bool) -> Void)?) {
        
        var longestAnimation = 0.0
        var longestAnimationIndex = -1
        var index = 0
        
        for textLayer in oldCharacterTextLayer {
            
            let duration = (TimeInterval(arc4random() % 100) / 200.0) + 0.25
            let delay = TimeInterval(arc4random() % 100) / 500.0
            
            if duration+delay > longestAnimation {
                longestAnimation = duration + delay
                longestAnimationIndex = index
            }
            CLMLayerAnimation.animation(textLayer, duration: duration, delay: delay, animations: {
                textLayer.opacity = 0
            }, completion: { finished in
                textLayer.removeFromSuperlayer()
                if textLayer == self.oldCharacterTextLayer[longestAnimationIndex] {
                    if let completionFunction = completion {
                        completionFunction(finished)
                    }
                }
            })
            
            index += 1
        }
    }
}
