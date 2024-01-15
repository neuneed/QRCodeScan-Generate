
//
//  ViewController.swift
//  QRCode
//
//  Created by Lee on 2016/10/26.
//  Copyright © 2016 dotc. All rights reserved.
//

import UIKit
import SnapKit
import Firebase


private let placeHolderTitle = "Type here to generate!".localized

class GenerateQRCodeViewController: UIViewController,UITextViewDelegate,GADInterstitialDelegate{

   
    public var contentTextView: UITextView! = UITextView()
    private var logoImageView: UIImageView! = UIImageView()
    private var QRCodeImageView: UIImageView! = UIImageView()
    
    var leftButtonItem :UIBarButtonItem! = UIBarButtonItem()
    var backButtonItem :UIBarButtonItem! = UIBarButtonItem()
    var needBack = Bool()
    
    //google ad
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = APPCOLOR
        self.title = "Generate".localized
        self.setupComponents()
        
        
        interstitial = createAndLoadInterstitial()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func initWithText(text:String)
    {
        contentTextView.text = text;
        needBack = true
    }
    
    func createAndLoadInterstitial() -> GADInterstitial{
        //google ad
        
        let adid1 = "" //nomal
        
        let newInterstitial = GADInterstitial(adUnitID: adid1)
        newInterstitial.delegate = self as GADInterstitialDelegate
        
        let request = GADRequest()

        #if arch(i386) || arch(x86_64)
        request.testDevices = [ kGADSimulatorID ]
        #endif
        
        newInterstitial.load(request)
        return newInterstitial
    }
    
    
    //MARK: -
    //MARK: Setup View
    private func setupComponents()
    {
        self.view.addSubview(contentTextView)
        self.automaticallyAdjustsScrollViewInsets = false

        contentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(64)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-55)
        }
    
        contentTextView.backgroundColor = UIColor.init(Hex: 0xececec)
        contentTextView.delegate = self
        contentTextView.placeholder = placeHolderTitle
        contentTextView.font = UIFont.systemFont(ofSize: 16.0)
        contentTextView.textAlignment = .left
        contentTextView.textContainerInset = UIEdgeInsetsMake(10 ,10, 10, 10);
//        contentTextView.returnKeyType = .done

                
        let generateItem = UIBarButtonItem(title: "Done".localized(), style: .plain, target: self, action: #selector(generateItemClick))
        navigationItem.rightBarButtonItem = generateItem
        
        let chooseLogoGes = UITapGestureRecognizer(target: self, action:#selector(chooseLogo))
        logoImageView.addGestureRecognizer(chooseLogoGes)
        
        leftButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(cancelItemClick(_:)))
        leftButtonItem.tag = 1001
        
        if needBack {
            backButtonItem = UIBarButtonItem(title: "Back".localized(), style: .plain, target: self, action: #selector(backItemClick(_:)))
            backButtonItem.tag = 101
            navigationItem.leftBarButtonItems = [backButtonItem,leftButtonItem]
        }
        else{
            navigationItem.leftBarButtonItem = leftButtonItem
        }
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        if contentTextView.text.characters.count == 0
        {
            return
            /*
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.contentTextView.becomeFirstResponder()
                self.leftButtonItem.title = "Cancel".localized
            }
            */
        }
        else
        {
            leftButtonItem.title = "Clear".localized
        }
    }
    
    
    //MARK: -
    //MARK: Target Action
//    @objc private func cancelItemClick() {
//        contentTextView.resignFirstResponder()
//    }
    
    func cancelItemClick(_ sender: UIBarButtonItem) {
        
        if sender.title == ""
        {
             return
        }
        else if sender.title == "Cancel".localized
        {
            contentTextView.resignFirstResponder()
        }
        else if sender.title == "Clear".localized
        {
            contentTextView.text = ""
            sender.title = ""
        }
    }
    
    
    func backItemClick(_ sender:UIBarButtonItem){
    
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearItemClick(){
        contentTextView.text = ""
    }
    
     @objc private func generateItemClick()
    {
        view.endEditing(true)

        guard let  content = contentTextView.text else
        {
            Tool.confirm(title: "Tips".localized, message: "Please input".localized, controller: self)
            return
        }
        
        if content.characters.count > 0
        {

            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                self.goToCodeEditViewController()
            }

        }
        else
        {
            Tool.confirm(title: "Tips".localized, message: "Please input".localized, controller: self)
        }
    }
    
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        self.goToCodeEditViewController()
    }
    
    func goToCodeEditViewController() {
        DispatchQueue.global().async {
            let suc:Bool = saveToLocal(test: self.contentTextView.text)
            if suc {
                HistoryViewController().reloadListData()
            }
            
            let image = self.contentTextView.text.generateQRCode()
            DispatchQueue.main.async(execute: {
                let qrcodeVC = QRCodeViewController()
                qrcodeVC.oldCodeImage = image
                qrcodeVC.setCodeImageViewImage(image: image)
                qrcodeVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(qrcodeVC, animated: true)
            })
        }
    }
    
    
    @objc private func chooseLogo()
    {
        
        Tool.shareTool.choosePicture(self, editor: true) { [weak self] (image) in
            self?.logoImageView.image = image
        }
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
//    {
//        
//        view.endEditing(true)
//
//    }

//    MARK: -
//    MARK: UITextViewDelegate
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView .resignFirstResponder()
//            self.generateItemClick()
//        }
//        return true
//    }    
    
    func textViewDidChange(_ textView: UITextView) {
//        let bytes = textView.text.lengthOfBytes(using: .utf8)
//        if bytes > 200 {
//            textView.endEditing(true)
//        }
    }
    
    
    //MARK: -- Keyboard observe
    func keyboardShow(notification: NSNotification)
    {
        leftButtonItem.title = "Cancel".localized()
    }
    
    func keyboardHidden(notification: NSNotification)
    {
        if contentTextView.text.characters.count == 0
        {
            leftButtonItem.title = ""
        }
        else
        {
            leftButtonItem.title = "Clear".localized()
        }
    }
}
