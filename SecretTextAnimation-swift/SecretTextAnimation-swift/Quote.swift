//
//  Quote.swift
//  SecretTextAnimation-swift
//
//  Created by shihao on 2017/9/6.
//
//

import UIKit

class Quote {
    
    // MARK: - properties
    
    let quote : String
    let author : String
    let image :UIImage
    
    // MARK: - initializers
    
    init(quote:String,author:String,image:UIImage) {
        self.quote = quote
        self.author = author
        self.image = image
    }
    
}
