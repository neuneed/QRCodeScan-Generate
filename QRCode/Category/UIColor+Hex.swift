//
//  UIColor+Hex.swift
//  QRCode
//
//  Created by Lee on 2016/11/1.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(Hex:Int) {
        self.init(red:(Hex >> 16) & 0xff, green:(Hex >> 8) & 0xff, blue:Hex & 0xff)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let red = CGFloat((hex >> 16) & 0xFF)/255.0
        let green = CGFloat((hex >> 8) & 0xFF)/255.0
        let blue = CGFloat((hex) & 0xFF)/255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
