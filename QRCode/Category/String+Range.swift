//
//  String+Range.swift
//  QRCode
//
//  Created by Lee on 2016/11/14.
//  Copyright © 2016 dotc. All rights reserved.
//

import Foundation


extension String
{
    subscript(index: Int) -> Character {
        get {
            return self[self.index(startIndex, offsetBy: index)]
        }
        set {
            let rangeIndex = self.index(startIndex, offsetBy: index)
            self.replaceSubrange(rangeIndex...rangeIndex, with: String(newValue))
        }
    }
    
    var length: Int {
        return self.characters.count
    }
    
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        
        return self[start...end]
    }
    
    
    func contain(str : String) -> Bool {
        return (self.range(of: str) != nil) ? true : false
    }
}


//useage

//let astr = "hello,swift3.0"
//let ch: Character = astr[3]
//let subStr1 = astr[1..<7]
//astr.contain(str: "p")
//astr.contain(str: "1")







