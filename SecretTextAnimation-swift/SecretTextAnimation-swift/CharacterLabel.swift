//
//  CharacterLabel.swift
//  SecretTextAnimation-swift
//
//  Created by shihao on 2017/9/6.
//
//

import UIKit
import QuartzCore
import CoreText

class CharacterLabel: UILabel,NSLayoutManagerDelegate {

    // MARK: - properties
    
    let textStorage = NSTextStorage(string : " ")
    let textContainer = NSTextContainer()
    let layoutManger = NSLayoutManager()
    
    var  oldCharacterTextLayer = [CATextLayer]()
    var characterTextLayer = [CATextLayer]()
    
   override var lineBreakMode: NSLineBreakMode {
        get{
           return super.lineBreakMode
        }
        set{
            textContainer.lineBreakMode = newValue
            super.lineBreakMode = newValue
        }
    }
    
    override var numberOfLines: Int {
        get{
            return super.numberOfLines
        }
        set{
            textContainer.maximumNumberOfLines = newValue
            super.numberOfLines = newValue
        }
    }
    
    override var bounds: CGRect {
        get{
            return super.bounds
        }
        set{
            textContainer.size = newValue.size
            super.bounds = newValue
        }
    }
    
    override var text: String! {
        get{
            return super.text
        }
        set{
            let wordRange = NSMakeRange(0, newValue.characters.count)
            let attributedText = NSMutableAttributedString (string: newValue)
            
            attributedText.addAttribute(NSForegroundColorAttributeName, value: self.textColor, range: wordRange)
            attributedText.addAttribute(NSFontAttributeName, value: self.font, range: wordRange)
            
            let paragraphoStyle = NSMutableParagraphStyle()
            paragraphoStyle.alignment = self.textAlignment
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphoStyle, range: wordRange)
            
            self.attributedText = attributedText
        }
    }

    
    override var attributedText: NSAttributedString? {
        get{
            return super.attributedText
        }
        set{
            if textStorage.string == newValue!.string {
                return
            }
            
            cleanOutOldCharacterTextLayers()
            oldCharacterTextLayer = [CATextLayer](characterTextLayer)
            textStorage.setAttributedString(newValue!)
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayoutManager()
    }
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayoutManager()
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayoutManager()
    }
    
    // MARK: - NSLayoutManagerDelegate
    
    func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        calculateTextLayers()
    }
    
    // MARK: - Convenience
    
    func calculateTextLayers() {
        characterTextLayer.removeAll(keepingCapacity: false)
        let attributedText = textStorage.string
        
        let wordRange = NSMakeRange(0, attributedText.characters.count)
        let attributedString = self.internalAttributedText()
        let layoutRect = layoutManger.usedRect(for: textContainer)
        
        var index = wordRange.location
        
        while index < wordRange.length + wordRange.location  {
            let glyphRange = NSMakeRange(index, 1)
            let characterRange = layoutManger.characterRange(forGlyphRange: glyphRange, actualGlyphRange:nil)
            let textContainer = layoutManger.textContainer(forGlyphAt: index, effectiveRange: nil)
            var glyphRect = layoutManger.boundingRect(forGlyphRange: glyphRange, in: textContainer!)
            let location = layoutManger.location(forGlyphAt: index)
            let kerningRange = layoutManger.range(ofNominallySpacedGlyphsContaining: index)
            
            if kerningRange.length > 1 && kerningRange.location == index {
                if characterTextLayer.count > 0 {
                    let previousLayer = characterTextLayer[characterTextLayer.endIndex-1]
                    var frame = previousLayer.frame
                    frame.size.width += glyphRect.maxX-frame.maxX
                    previousLayer.frame = frame
                }
            }
            
            glyphRect.origin.y += location.y-(glyphRect.height/2)+(self.bounds.size.height/2)-(layoutRect.size.height/2)
            
            let textLayer = CATextLayer(frame: glyphRect, string: (attributedString?.attributedSubstring(from: characterRange))!)
            initialTextLayerAttributes(textLayer)
            
            layer.addSublayer(textLayer)
            characterTextLayer.append(textLayer)
            index += characterRange.length
        }
    }
    
    func setupLayoutManager() {
        
        textStorage.addLayoutManager(layoutManger)
        layoutManger.addTextContainer(textContainer)
        textContainer.size = bounds.size
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode
        layoutManger.delegate = self
    }
    
    func initialTextLayerAttributes(_ textLayer: CATextLayer) {
        
    }
    
    func internalAttributedText() -> NSMutableAttributedString! {
        let wordRange = NSMakeRange(0, textStorage.string.characters.count)
        let attributedText = NSMutableAttributedString(string: textStorage.string)
        attributedText.addAttribute(NSForegroundColorAttributeName , value: self.textColor.cgColor, range:wordRange)
      //  attributedText.addAttribute(NSBackgroundColorAttributeName , value: UIColor.red.cgColor, range:wordRange)
        attributedText.addAttribute(NSFontAttributeName , value: self.font, range:wordRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        attributedText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range: wordRange)
        
        return attributedText
    }
    
    func cleanOutOldCharacterTextLayers() {
        for textLayer in oldCharacterTextLayer {
            textLayer.removeFromSuperlayer()
        }
        
        oldCharacterTextLayer.removeAll(keepingCapacity: false)
    }

}


