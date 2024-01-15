//
//  ViewController.swift
//  QRCode
//
//  Created by Lee on 2016/10/26.
//  Copyright © 2016 dotc. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import PKHUD
import JSQWebViewController
import SwiftyUserDefaults


private let scanAnimationDuration = 3.0//扫描时长
private var topHeight :CGFloat! = 80.0

class ScanQRCodeViewController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    
    var scanSession = AVCaptureSession()
    lazy var scanView : UIImageView =
    {
        let scanView = UIImageView()
        
        let topView = UIView()
        let leftView = UIView()
        let rightView = UIView()
        let bottomView = UIView()
        let centerView = UIImageView()
        
        scanView.addSubview(topView)
        scanView.addSubview(leftView)
        scanView.addSubview(rightView)
        scanView.addSubview(bottomView)
        scanView.addSubview(centerView)
        
        let centerViewHeight = SCREEN_WIDTH - 100
        let top_and_bottom_height = (self.view.frame.size.height - 150 - 64 - centerViewHeight)/2
        topHeight = top_and_bottom_height
        
        topView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(top_and_bottom_height)
        })
        
        bottomView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(top_and_bottom_height)
        })
        
        leftView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.width.equalTo(50)
            make.bottom.equalTo(bottomView.snp.top)
        })
        
        rightView.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.width.equalTo(50)
            make.bottom.equalTo(bottomView.snp.top)
        })
        
        centerView.snp.makeConstraints({ (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
            make.left.equalTo(leftView.snp.right)
            make.right.equalTo(rightView.snp.left)
        })
       
        let bgColor = UIColor(red:0/255,green:0/255,blue:0/255,alpha:0.4)
        topView.backgroundColor = bgColor
        bottomView.backgroundColor = bgColor
        leftView.backgroundColor = bgColor
        rightView.backgroundColor = bgColor
        centerView.backgroundColor = UIColor.clear
        centerView.image = UIImage(named:"corner")
        
        return scanView
    }()
    
    lazy var scanLine : UIImageView =
        {
            
            let scanLine = UIImageView()
            scanLine.frame = CGRect(x: 52.5, y: topHeight, width: self.scanView.bounds.width-105, height: 8)
            scanLine.image = UIImage(named: "scanline")
            scanLine.backgroundColor = UIColor.clear
            
            return scanLine
            
    }()
    
    var activityIndicatorView: UIActivityIndicatorView! = UIActivityIndicatorView()

    lazy var downBgView = UIView()
    lazy var flashBtn = UIButton()
    lazy var cameraBtn = UIButton()
    lazy var tipsLabel = UILabel()
    var lightOn = false


    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
//        let scanSuccessVC = ScanSuccessViewController.init()
//        let navigationVC = UINavigationController.init(rootViewController: scanSuccessVC)
//        scanSuccessVC.setMessage(text: "爱词霸权威在线词典,为您提供slogan的中文意思,slogan的用法讲解,slogan的读音,slogan的同义词,slogan的反义词,slogan的例句等英语服务。")
//        self.navigationController?.present(navigationVC, animated: true, completion: {
//            
//        })
        
        
        self.view.backgroundColor = UIColor(Hex: 0xEAEEF1)
        self.title = "Scan".localized
        
        self.view.addSubview(scanView)
        scanView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.view.snp.top).offset(64)
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).offset(-150)
        }
//        scanView.backgroundColor = UIColor(red:57/255,green:56/255,blue:62/255,alpha:0.5)
//        scanView.image = UIImage(named:"corner")
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = CGRect(x:0 ,y:0 ,width:35 ,height:35)
        activityIndicatorView.center = self.view.center
        
        let tabbarHeight :CGFloat! = self.tabBarController?.tabBar.frame.size.height
        self.view.addSubview(downBgView)
        downBgView.snp.makeConstraints { (make) in
            make.top.equalTo(scanView.snp.bottom)
            make.bottom.equalTo(self.view.snp.bottom).offset(-tabbarHeight)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        downBgView.backgroundColor = UIColor(Hex: 0xEAEEF1)
        addSubButton()
        
        view.layoutIfNeeded()
        scanView.addSubview(scanLine)

        self.setupScanSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startScan()
    }
    
    func addSubButton() {
        downBgView.addSubview(flashBtn)
        downBgView.addSubview(cameraBtn)
        downBgView.addSubview(tipsLabel)
        
        let btn_height = 35
        
        flashBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:btn_height,height:btn_height))
            make.left.equalTo(downBgView.snp.left).offset(60)
            make.centerY.equalTo(downBgView.snp.centerY).offset(-20)
        }
        
        cameraBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:btn_height,height:btn_height))
            make.right.equalTo(downBgView.snp.right).offset(-60)
            make.centerY.equalTo(downBgView.snp.centerY).offset(-20)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(cameraBtn.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        
        tipsLabel.textAlignment = .center
        tipsLabel.textColor = UIColor.gray
        tipsLabel.font = UIFont.italicSystemFont(ofSize: 12)
        tipsLabel.text = "Scan_tips".localized()
        
        
        flashBtn.setImage(UIImage(named: "flash"), for: UIControlState.normal)
        flashBtn.setImage(UIImage(named: "flash_h"), for: UIControlState.selected)
        cameraBtn.setImage(UIImage(named: "album"), for: UIControlState.normal)
                
        flashBtn.addTarget(self, action: #selector(self.light(_:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(self.photo(_:)), for: .touchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -
    //MARK:   Scan
    
    func setupScanSession(){
        do
        {
            //设置捕捉设备
            let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            //设置设备输入输出
            let input = try AVCaptureDeviceInput(device: device)
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //设置会话
            let  scanSession = AVCaptureSession()
            scanSession.canSetSessionPreset(AVCaptureSessionPresetHigh)
            
            if scanSession.canAddInput(input)
            {
                scanSession.addInput(input)
            }
            
            if scanSession.canAddOutput(output)
            {
                scanSession.addOutput(output)
            }
            
            //设置扫描类型(二维码和条形码)
            output.metadataObjectTypes = [
                AVMetadataObjectTypeQRCode,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode128Code,
                AVMetadataObjectTypeCode39Mod43Code,
                AVMetadataObjectTypeEAN13Code,
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeCode93Code]
            
            //预览图层
            let scanPreviewLayer = AVCaptureVideoPreviewLayer(session:scanSession)
            scanPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            scanPreviewLayer!.frame = view.layer.bounds
            
            view.layer.insertSublayer(scanPreviewLayer!, at: 0)
            
            //设置扫描区域
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil, using: { (noti) in
                output.rectOfInterest = (scanPreviewLayer?.metadataOutputRectOfInterest(for: self.scanView.frame))!
            })
            
            //保存会话
            self.scanSession = scanSession
            
        }
        catch
        {
            //摄像头不可用
            Tool.confirm(title: "Tips".localized, message: "Camera unavailable".localized, controller: self)
            return
        }
    }
    
    //开始扫描
    public func startScan()
    {
        if !self.scanSession.isRunning
        {
            #if arch(i386) || arch(x86_64)
                //simulator
                return
                
            #else
                //device
                self.scanSession.startRunning()
                
            #endif
        }
        scanLine.layer.add(scanAnimation(), forKey: "scan")
    }
    
    public func stopSacn()
    {
        if self.scanSession.isRunning
        {
            self.scanSession.stopRunning()
        }
        
        scanLine.layer.removeAnimation(forKey: "scan")
    }
    
    
    //扫描动画
    private func scanAnimation() -> CABasicAnimation
    {
        let startPoint = CGPoint(x: scanLine .center.x  , y: topHeight+3)
        let endPoint = CGPoint(x: scanLine.center.x, y:scanView.frame.size.height-topHeight-3)
        
        let translation = CABasicAnimation(keyPath: "position")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.fromValue = NSValue(cgPoint: startPoint)
        translation.toValue = NSValue(cgPoint: endPoint)
        translation.duration = scanAnimationDuration
        translation.repeatCount = MAXFLOAT
        translation.autoreverses = true
        
        return translation
    }
    

    
    //MARK: -
    //MARK: Button func
    
    //闪光灯
    @IBAction func light(_ sender: UIButton)
    {
        
        lightOn = !lightOn
        sender.isSelected = lightOn
        turnTorchOn()
        
    }
    
    
    //相册
    @IBAction func photo(_ sender: UIButton)
    {
        
        Tool.shareTool.choosePicture(self, editor: true, options: .photoLibrary) {[weak self] (image) in
            
            self?.stopSacn()
            self!.activityIndicatorView.startAnimating()
            
            DispatchQueue.global().async {
                let recognizeResult = image.recognizeQRCode()
                let result = recognizeResult?.characters.count > 0 ? recognizeResult : "Unrecognized".localized
                DispatchQueue.main.async
                {
                    if result == "Unrecognized".localized
                    {
                        HUD.flash(.label(result), delay: 1.5) { _ in
                            self?.startScan()
                        }
                        self!.activityIndicatorView.stopAnimating()
                        return
                    }
                    self!.activityIndicatorView.stopAnimating()
                    AudioServicesPlaySystemSound(1109)
                    self?.successScanToAlert(message: (result)!)
                }
            }
        }
        
    }
    
    ///闪光灯
    private func turnTorchOn()
    {
        
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else
        {
            
            if lightOn
            {
                
                Tool.confirm(title: "Tips".localized, message: "The flash is not available".localized, controller: self)
                
            }
            
            return
        }
        
        if device.hasTorch
        {
            do
            {
                try device.lockForConfiguration()
                
                if lightOn && device.torchMode == .off
                {
                    device.torchMode = .on
                }
                
                if !lightOn && device.torchMode == .on
                {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            }
            catch{ }
            
        }
    }

    
    
    //MARK: -
    //MARK: AVCaptureMetadataOutputObjects Delegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
    {
        if metadataObjects.count > 0
        {
         
            let resoutObj :AVMetadataMachineReadableCodeObject? = metadataObjects.first as! AVMetadataMachineReadableCodeObject?
            
            if resoutObj != nil
            {
                
                AudioServicesPlaySystemSound(1109)
//                1014
                // https://github.com/TUNER88/iOSSystemSoundsLibrary sound Library
                
                let messageCode = resoutObj?.stringValue
                self.successScanToAlert(message: messageCode!)
            }
        }
    }
    
    func modalPopView(_ type:PopViewType){
//        let popVc = PopViewController()
//        popVc.popType = type
////        popVc.transitioningDelegate = animationDelegate
//        animationDelegate.popViewType = type
//        popVc.modalPresentationStyle = UIModalPresentationStyle.custom
//        popVc.selectDelegate = self
//        present(popVc, animated: true, completion: nil)
        
//        https://github.com/Heisenbean/PopView/blob/master/PopView/Resource/CommonTool.swift
    }
    
    
    func successScanToAlert(message: String) {
        self.stopSacn()
        
        let suc:Bool = saveToLocal(test: message)
        if suc {
            HistoryViewController().reloadListData()
        }
        
        
        let scanSuccessVC = ScanSuccessViewController.init()
        let navigationVC = UINavigationController.init(rootViewController: scanSuccessVC)
        scanSuccessVC.setMessage(text: message)
        self.navigationController?.present(navigationVC, animated: true, completion: { 
            
        })
        
        
        return
        // Pop View
        //modalPopView(PopViewType.center)
        //return
        // Alert View
        let title = "Code message".localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Copy code message".localized, style: UIAlertActionStyle.default, handler:{
            (alert: UIAlertAction!) in
            
            self.copyToClipboard(textMessage: message)
        }))
        
        alert.addAction(UIAlertAction(title: "Share".localized, style: UIAlertActionStyle.default, handler:{
            (alert: UIAlertAction!) in
            self.systemShare(textMessage: message)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Open in safari".localized, style: UIAlertActionStyle.destructive, handler:{
            (alert: UIAlertAction!) in
            self.safariHandle(textMessage: message)
            self.startScan()
        }))
        
        alert.addAction(UIAlertAction(title: "Save".localized, style: UIAlertActionStyle.default, handler:{
            (alert: UIAlertAction!) in
           
            let suc:Bool = saveToLocal(test: message)
            if suc {
                HistoryViewController().reloadListData()
            }
            
            self.startScan()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler:{
            (alert: UIAlertAction!) in
            self.startScan()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func safariHandle(textMessage : String?)
    {
        if ((textMessage?.hasPrefix("http://"))! || (textMessage?.hasPrefix("https://"))!)
        {
            let openInSafari = Defaults[.openInSafari]
            
            if openInSafari == false
            {
                UIApplication.shared.openURL(NSURL(string:textMessage!)! as URL)
            }
            else
            {   
                let controller = WebViewController(url: URL(string: textMessage!)!)
                let nav = UINavigationController(rootViewController: controller)
                present(nav, animated: true, completion: nil)
            }
            //TODO: TODO: Maybe url scherm like http://weixin.....
     
        }
        else if(textMessage?.hasPrefix("www"))!
        {
            var newUrlStr = "https://" + textMessage!
            if !UIApplication.shared.canOpenURL(NSURL(string:newUrlStr)! as URL)
            {
                newUrlStr = "http://" + textMessage!
            }
            
            let openInSafari = Defaults[.openInSafari]
            if openInSafari == false
            {
                UIApplication.shared.openURL(NSURL(string:newUrlStr)! as URL)
            }
            else
            {
                let controller = WebViewController(url: URL(string: newUrlStr)!)
                let nav = UINavigationController(rootViewController: controller)
                present(nav, animated: true, completion: nil)
            }
            
        }
        else
        {
            let ecodingStr = textMessage?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let newUrlForGoogle = "https://www.google.com/search?q=" + ecodingStr!
            UIApplication.shared.openURL(NSURL(string:newUrlForGoogle)! as URL)
        }
    }
    
    private func copyToClipboard(textMessage : String?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = textMessage
        HUD.flash(.label("Copy to clipboard success.".localized), delay: 1.5) { _ in
            self.startScan()
        }
    }
    
    private func systemShare(textMessage: String?)
    {
        let activityViewController = UIActivityViewController(
            activityItems: [(textMessage as NSString!)],
            applicationActivities: nil)
        if activityViewController.popoverPresentationController != nil {
            
        }
        present(activityViewController, animated: true, completion:nil)
        activityViewController.completionWithItemsHandler = {
            (str, done, items, error) in
            self.startScan()
        }
     }

}

//extension ViewController:DidSelectPopViewCellDelegate{
//    func didSelectRowAtIndexPath(_ indexPath: IndexPath) {
//        print("点击了第\(indexPath.row)个")
//    }
//}

