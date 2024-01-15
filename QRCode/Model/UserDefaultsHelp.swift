//
//  UserDefaultsHelp.swift
//  QRCode
//
//  Created by sidechef on 2017/5/7.
//  Copyright © 2017年 dotc. All rights reserved.
//

import Foundation


let userDefaults = UserDefaults.standard
let defaultKey = "QRCodeUserGenDataArray"
let defaultText = "UserDicText"
let defaultTime = "UserDicTime"


public func saveToLocal(test:String) -> Bool {
    
    let date = NSDate()
    let userDic = [
        defaultText : test,
        defaultTime : date
        ] as Dictionary
    
    var localContent = getTheLocal()
    localContent.insert(userDic, at: 0)
    
    userDefaults.setValue(localContent, forKey: defaultKey)
    let isSucccess = userDefaults.synchronize()
    return isSucccess
}



func getTheLocal() -> Array<Any>{
    let dt = userDefaults.object(forKey: defaultKey)
    if dt == nil {
        return []
    }
    else{
        //暂时只允许存储50个数据
        var result  = dt as! Array<Any>
        if result.count > 80 {
            result.removeLast()
        }
        return result
    }
}


public func clearAllHistory() -> Bool{
    userDefaults.setValue([], forKeyPath: defaultKey)
    let isSucccess = userDefaults.synchronize()
    return isSucccess
}


public func reSaveData(newData : Array<Any>){
    clearAllHistory()
    userDefaults.setValue(newData, forKey: defaultKey)
    userDefaults.synchronize()
}



//MARK - AD
func needShowAD() -> Bool {
    let dts = userDefaults.bool(forKey: "FirebaseAnalyticsHelp")
    return dts
}


//这个KEY其实是控制AD显示隐藏的！
func setAdShow(show: Bool) {
    userDefaults.set(show, forKey: "FirebaseAnalyticsHelp")
    userDefaults.synchronize()
}
