//
//  TabbarViewController.swift
//  QRCode
//
//  Created by Lee on 2016/10/26.
//  Copyright © 2016 dotc. All rights reserved.
//

import Foundation
import UIKit


class TabbarViewController: UITabBarController ,UITabBarControllerDelegate
{
    let scanVC :ScanQRCodeViewController! = ScanQRCodeViewController()
    let generateVC :GenerateQRCodeViewController! = GenerateQRCodeViewController()
    let historyVC :HistoryViewController! = HistoryViewController()
    let settingVC :SettingViewController! = SettingViewController()



    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let scanNavi = UINavigationController.init(rootViewController: scanVC)
        let generateNavi = UINavigationController.init(rootViewController: generateVC)
        let historyNavi = UINavigationController.init(rootViewController: historyVC)
        let settingNavi = UINavigationController.init(rootViewController: settingVC)
        
        scanNavi.navigationBar.tintColor = TIPSCOLOR
        generateNavi.navigationBar.tintColor = TIPSCOLOR
        historyNavi.navigationBar.tintColor = TIPSCOLOR
        settingNavi.navigationBar.tintColor = TIPSCOLOR
        

        scanVC.tabBarItem.image = UIImage(named:"scan")
        generateVC.tabBarItem.image = UIImage(named:"generate")
        historyVC.tabBarItem.image = UIImage(named:"history")
        settingVC.tabBarItem.image = UIImage(named:"setting")
        
        scanVC.tabBarItem.title = "Scan".localized
        generateVC.tabBarItem.title = "Generate".localized
        historyVC.tabBarItem.title = "History".localized
        settingVC.tabBarItem.title = "Setting".localized
        
        scanVC.tabBarItem.tag = 0
        generateVC.tabBarItem.tag = 1
        historyVC.tabBarItem.tag = 2
        settingVC.tabBarItem.tag = 3
        
        
        self.viewControllers = [scanNavi,generateNavi,historyNavi,settingNavi]
        self.tabBar.tintColor = TIPSCOLOR
        self.tabBar.barTintColor = UIColor.white
        
        //change font ofSize
        let attributesNormal = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 10.5)
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
    }
    
    //MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
}
