//
//  Help.swift
//  QRCode
//
//  Created by Lee on 2016/11/5.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let APPCOLOR = UIColor(Hex: 0xEAEEF1)


//let TIPSCOLOR = UIColor(Hex: 0xd0021b)
let TIPSCOLOR = UIColor(Hex: 0xdb3a36)
let CODE_TABBAR_BGCOLOR = UIColor(Hex: 0xDADADA)


//MARK:- UserDefaults
extension DefaultsKeys {
    static let openInSafari = DefaultsKey<Bool?>("openInSafari")
}



//用户二维码数据
extension UserDefaults {
    subscript(key: DefaultsKey<CodeMessage?>) -> CodeMessage? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

extension DefaultsKeys {
    static let superman = DefaultsKey<CodeMessage?>("codeMessage")
}


//MARK:- SystemInfo
func appVersion() -> String {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return version
    }
    return "no version info"
}

func appBuild() -> String {
    let appBundle = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    return appBundle
}

func versionBuild() -> String {
    let version = appVersion(), build = appBuild()
    
    return version == build ? "v\(version)" : "v\(version)(\(build))"
}


func systemVersion() -> String {
    return UIDevice.current.systemVersion
}


