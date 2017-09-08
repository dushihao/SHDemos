//
//  ViewController.swift
//  SecretTextAnimation-swift
//
//  Created by shihao on 2017/9/6.
//
//

import UIKit

class ViewController: UIViewController {

    struct Constants {
        struct Images {
            static let one = "one"
            static let two = "two"
            static let three = "three"
            static let four = "four"
            static let five = "five"
            static let six = "six"
            static let seven = "seven"
            static let eight = "eight"
            static let nine = "nine"
            static let ten = "ten"
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    var quoteLabel: FadingLabel!
    let animationDuration: TimeInterval = 1.0
    let switchingInterval: TimeInterval = 3.0
    var currentIndex = 0
    
    let quotes = [
        Quote(quote: "混混噩噩的生活不值得过", author: "Socrates", image: UIImage(named: Constants.Images.one)!),
        Quote(quote: "我们可以体验的最美丽的事情是神秘的它是所有真正的艺术和科学的源泉", author: "Albert Einstein", image: UIImage(named: Constants.Images.two)!),
        Quote(quote: "\"我不偷取胜利\"", author: "Alexander the Great", image: UIImage(named: Constants.Images.three)!),
        Quote(quote: "神经病吧为什么文字会重叠在一起啊神经病吧还百度不出来", author: "Shihao Du", image: UIImage(named: Constants.Images.four)!),
        Quote(quote: "\"Decide... whether or not the goal is worth the risks involved. If it is, stop worrying....\"", author: "Amelia Earhart", image: UIImage(named: Constants.Images.five)!),
//        Quote(quote: "\"I've failed over and over and over again in my life and that is why I succeed.\"", author: "Michael Jordan", image: UIImage(named: Constants.Images.six)!),
//        Quote(quote: "\"Kind words can be short and easy to speak, but their echoes are truly endless.\"", author: "Mother Teresa", image: UIImage(named: Constants.Images.seven)!),
//        Quote(quote: "\"Live as if you were to die tomorrow; learn as if you were to live forever.\"", author: "Mahatma Gandhi", image: UIImage(named: Constants.Images.eight)!),
//        Quote(quote: "\"Somewhere, something incredible is waiting to be known.\"", author: "Carl Sagan", image: UIImage(named: Constants.Images.nine)!),
//        Quote(quote: "\"It is not death that a man should fear, but he should fear never beginning to live.\"", author: "Marcus Aurelius", image: UIImage(named: Constants.Images.ten)!),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpCharacterLabel()
        setBackGroudImageView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackgroundImageView()
    }
    
    func animateBackgroundImageView() {
        
        // Quote is switched here so it is in sync with the image switching.
        switchQuote()
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = DispatchTime.now() + Double(Int64(self.switchingInterval * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.animateBackgroundImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        
        
        imageView.layer.add(transition, forKey: kCATransition)
        imageView.image = quotes[currentIndex].image
        
        CATransaction.commit()
        
        // Increase index to switch both the quote and image to the next.
        currentIndex = currentIndex < quotes.count - 1 ? currentIndex + 1 : 0
    }
    
    func switchQuote() {
        quoteLabel.text = "" // Clear label before switching to a new quote.
        quoteLabel.text = quotes[currentIndex].quote + "\n\n" + quotes[currentIndex].author
    }
    
    func setBackGroudImageView() {
        imageView.image = quotes[currentIndex].image
    }
 
    func setUpCharacterLabel() {
        
        quoteLabel = FadingLabel(frame: CGRect(x: 20, y: 20, width: 120, height: 120))
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.textAlignment = NSTextAlignment.center
        quoteLabel.font = UIFont.systemFont(ofSize: 27)
        quoteLabel.textColor = UIColor.white
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.numberOfLines = 0
        
        self.view.addSubview(quoteLabel)
        
        NSLayoutConstraint.activate([
            
            quoteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            quoteLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.05)
            ])
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }

}

