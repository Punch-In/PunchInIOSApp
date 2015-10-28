//
//  InstructorCourseView.swift
//  PunchIn
//
//  Created by Nilesh Agrawal on 10/28/15.
//  Copyright © 2015 Nilesh Agrawal. All rights reserved.
//

import UIKit

class InstructorCourseView: UIView {

    var initialCenterPoint:CGPoint?
    
    @IBOutlet var ContentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    
    var image: UIImage? {
        get {return imageView.image}
        set {imageView.image = newValue}
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "DraggableImageView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        ContentView.frame = bounds
        addSubview(ContentView)
        
        // custom initialization logic
        
    }
    
    
    
    
    @IBAction func someAction(sender:UIPanGestureRecognizer){
        let translation = sender.translationInView(superview)
        print("SomeAction")
        let location = sender.locationInView(ContentView)
        
        switch sender.state {
        case .Began:
            initialCenterPoint = self.center
            
            //CGPointMake(imageView.bounds.size.width/2, imageView.bounds.size.height/2)
            print(initialCenterPoint)
        case .Cancelled:
            fallthrough
        case .Ended:
            fallthrough
        case .Failed:
            fallthrough
        case .Possible:
            fallthrough
        case .Changed:
            
            
            print(translation.x)
            self.center.x = (initialCenterPoint?.x)! + translation.x
            self.center.y = (initialCenterPoint?.y)! + translation.y
            print("AAA \(self.center)")
            
            if(translation.x < 50 && translation.x > -50){
                if(location.y < ContentView.bounds.height/2){
                    
                    
                    self.ContentView.transform = CGAffineTransformMakeRotation((translation.x * CGFloat(M_PI)) / 360.0)
                    
                    
                }else{
                    self.ContentView.transform = CGAffineTransformMakeRotation(( -1*translation.x * CGFloat(M_PI)) / 360.0)
                }
            }
            
            
            if(translation.x > 50 ){
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.ContentView.center.x = 600
                    
                })
            }
            if(translation.x < -50 ){
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.ContentView.center.x = -600
                    
                })
            }
            
            
        }
        
    }
    
    
}
