//
//  AnimatedImageView.swift
//  QRCode
//
//  Created by Lee on 2016/11/14.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation

class AnimatedImageView: UIImageView {
    
    override var image: UIImage!{
        get {
            return super.image
        }
        set
        {
            let transition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = "rippleEffect"
            transition.startProgress = 0.0
            transition.endProgress = 1.0
            self.layer.add(transition, forKey: "setimageanimation")
            super.image = newValue
        }
    }
    
   
    /*
    override var backgroundColor: UIColor?{
        
        get{
            return super.backgroundColor
        }
        set{
            let transition = CATransition()
            transition.duration = 1.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = "rippleEffect"
            transition.startProgress = 0.0
            transition.endProgress = 1.0
            self.layer.add(transition, forKey: "setimageanimation")
            super.backgroundColor = newValue
        }
    
    }
     */

}
