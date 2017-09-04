//
//  ViewController.swift
//  ProgressAnimation-Swift
//
//  Created by shihao on 2017/8/31.
//  Copyright © 2017年 shihao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var progressView: Progress!
    @IBOutlet weak var percentlabel: UILabel!
    
    let total : CGFloat = 128
    let currentRange: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressView.curValue = CGFloat(currentRange)
        progressView.range = CGFloat(total)
    }


    @IBAction func incrementProgress(_ sender: UIButton) {
        
        guard progressView.curValue < progressView.range else {
            return
        }
        
        let incrementRange = 8
        progressView.curValue = progressView.curValue + CGFloat(incrementRange)
        
        //label content
        let percent = progressView.curValue / progressView.range
        self.percentlabel.text = numberFromPercentage(Double(percent))
    }
    
    func numberFromPercentage(_ number : Double) -> String {
        
        let numberformat = NumberFormatter()
        numberformat.numberStyle = .percent
        numberformat.percentSymbol = ""
        return numberformat.string(from: NSNumber(value:number))!
    }

}

