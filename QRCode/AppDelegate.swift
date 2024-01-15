//
//  AppDelegate.swift
//  QRCode
//
//  Created by Lee on 2016/10/26.
//  Copyright © 2016年 dotc. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Firebase
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabbarVC : TabbarViewController!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        let userHasOnboarded =  defaults.bool(forKey: "userHasOnboarded")
        if userHasOnboarded == true {
            self.setupNormalRootViewController()
//            self.window?.rootViewController = self.generateStandardOnboardingVC()
        }
        else {
            self.window?.rootViewController = self.generateStandardOnboardingVC()
        }
        
      
        self.window?.makeKeyAndVisible()
        
        Bugly.start(withAppId: "")
        
        let openInSafari = Defaults[.openInSafari]
        if openInSafari == nil
        {
            Defaults[.openInSafari] = false
        }
        
        //google admob
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "")
        
//        setAdShow(show: true)
        return true
    }
    
    
    func setupNormalRootViewController (){
        tabbarVC = TabbarViewController()
        self.window?.rootViewController = tabbarVC
        UserDefaults.standard.set(true, forKey: "userHasOnboarded")
    }
    
    func handleOnboardingCompletion (){
        self.setupNormalRootViewController()
    }
    
    func skip (){
        self.setupNormalRootViewController()
        
    }
    
    
    
    func generateStandardOnboardingVC () -> OnboardingViewController {
        
        // Initialize onboarding view controller
        var onboardingVC = OnboardingViewController()
        
        // Create slides
        let firstPage = OnboardingContentViewController.content(withTitle: "Welcome To:".localized(), body: "QRCode Fun App".localized(), image: nil, buttonText: nil, action: nil)
        let secondPage = OnboardingContentViewController.content(withTitle: "Frist Of All:".localized(), body: "Find a QRCode image you want to know then use the camera scanner.".localized(), image: nil, buttonText: nil, action: nil)
        let thirdPage = OnboardingContentViewController.content(withTitle: "Then You Can:".localized(), body: "Edit,Open,Copy text or Generate a brand-new coloful code!".localized(), image: nil, buttonText: nil, action: self.handleOnboardingCompletion)
        
        
        // Define onboarding view controller properties
        onboardingVC = OnboardingViewController.onboard(withBackgroundImage: UIImage(named: "FristLaunchPage"), contents: [firstPage, secondPage, thirdPage])
        onboardingVC.shouldFadeTransitions = true
//        onboardingVC.shouldMaskBackground = false
//        onboardingVC.shouldBlurBackground = false
        onboardingVC.fadePageControlOnLastPage = true
        onboardingVC.pageControl.pageIndicatorTintColor = UIColor.darkGray
        onboardingVC.pageControl.currentPageIndicatorTintColor = UIColor.white
        onboardingVC.skipButton.setTitleColor(UIColor.white, for: .normal)
        onboardingVC.allowSkipping = true
        onboardingVC.fadeSkipButtonOnLastPage = false
        onboardingVC.underPageControlPadding = 10
        
        
        onboardingVC.skipHandler = {
            self.skip()
        }
        
        return onboardingVC
        
    }
    
    
    
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    

  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        tabbarVC.scanVC.stopSacn()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        tabbarVC.scanVC.startScan()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

