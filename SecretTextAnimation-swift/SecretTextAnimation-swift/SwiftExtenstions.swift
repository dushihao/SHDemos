//
//  SwiftExtenstions.swift
//  SecretTextAnimation-swift
//
//  Created by shihao on 2017/9/6.
//
//

import UIKit

extension CATextLayer {
    convenience init(frame:CGRect,string:NSAttributedString) {
        self.init()
        self.contentsScale = UIScreen.main.scale
        self.frame = frame
        self.string = string
    }
}
