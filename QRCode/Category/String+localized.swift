//
//  String+localized.swift
//  QRCode
//
//  Created by Lee on 2016/11/5.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation

extension String
{
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func localizedWithComment(comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
    func localized(comment: String = "") -> String
    {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
    
}

