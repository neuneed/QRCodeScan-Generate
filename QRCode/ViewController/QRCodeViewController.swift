//
//  QRCodeViewController.swift
//  QRCode
//
//  Created by Lee on 2016/11/1.
//  Copyright © 2016 dotc. All rights reserved.
//

import Foundation
import UIKit
import PKHUD
import SVProgressHUD
import Firebase


let cellIdentifier = "QRCodeChangeSkinCellId"
let cellHeight = 46
let bottomViewHeight = 45.0


class QRCodeViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var codeBackView = AnimatedImageView()
    var codeImageView = UIImageView()
    var iconImageView = UIImageView()
    let segmentedControl = TwicketSegmentedControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
    @IBOutlet var bannerView: GADBannerView!

    //MARK: Setting Config
    var selectIndex = 0
    var oldCodeImage = UIImage()

    //MARK: Cell Config
    let codeColors = [0x0,0xffffff, 0xAB3633 ,0x14c98e ,0xffef51,0x32a6fc ,0xff8926 ,0xff4a26,0x252525 ,0xececec, 0xFBCC05 , 0xF87809, 0x25A09B, 0x492AAB, 0x0358EB,0x082C3E,0x40AD99]
    
    let bgImages = [UIImage(named:"openlb"),
                    UIImage(named:"bg_image0"),
                    UIImage(named:"bg_image1"),
                    UIImage(named:"bg_image2"),
                    UIImage(named:"bg_image3"),
                    UIImage(named:"bg_image4"),
                    UIImage(named:"bg_image5"),
                    UIImage(named:"bg_image6"),
                    UIImage(named:"bg_image7"),
                    UIImage(named:"bg_image8"),
                    UIImage(named:"bg_image9"),
                    UIImage(named:"bg_image10"),
                    UIImage(named:"bg_image11"),
                    UIImage(named:"bg_image12"),
                    UIImage(named:"bg_image13"),
                    UIImage(named:"bg_image14"),
                    UIImage(named:"bg_image15"),
                    UIImage(named:"bg_image16"),
                    UIImage(named:"bg_image17"),
                    UIImage(named:"bg_image18"),
                    UIImage(named:"bg_image19"),
                    UIImage(named:"bg_image20"),
                    UIImage(named:"bg_image21"),
                    UIImage(named:"bg_image22"),
                    UIImage(named:"bg_image23"),
                    UIImage(named:"bg_image24"),
                    UIImage(named:"bg_image25"),
                    UIImage(named:"bg_image26")]

    let bgColors = [0xffffff,0x252525 ,0xececec,0x14c98e ,0xffef51,0x32a6fc ,0xff8926 ,0xff4a26,0x0F74BE , 0xF0EE37 , 0xEBBFB7, 0x9CCBAE, 0xFEEFA9, 0x78CDFD,0xC7EBF3,0xFCE4C3,0xEBA0BE,0xD4E0EC,0xCDD3DA]
    
    
    
    let iconImages = [ UIImage(named:"delete"),
                       UIImage(named:"openlb"),
                       
                       UIImage(named:"facebook"),
                       UIImage(named:"twitter"),
                       UIImage(named:"instagram"),
                       UIImage(named:"flickr"),
                       UIImage(named:"tumblr"),
                       UIImage(named:"linkedin"),

                       
                       UIImage(named:"wechat"),
                       UIImage(named:"wechat2"),
                       UIImage(named:"douban"),
                       UIImage(named:"taobao"),
                       UIImage(named:"weibo"),
                       UIImage(named:"momo"),
                       UIImage(named:"qzone"),
                       UIImage(named:"tieba"),
                       UIImage(named:"zhihu"),
                       
                       UIImage(named:"youtube"),
                       UIImage(named:"spotify"),
                       UIImage(named:"twitch"),
                       UIImage(named:"vimeo"),
                       
                       UIImage(named:"500px"),
                       UIImage(named:"dribbble"),
                       UIImage(named:"pinterest"),
                       
                       UIImage(named:"fancy"),
                       UIImage(named:"imdb"),
                       UIImage(named:"kickstarter"),
                       
        
                       UIImage(named:"dropbox"),
                       UIImage(named:"itunes-store"),
                       UIImage(named:"amazon"),
                       UIImage(named:"airbnb"),
                       UIImage(named:"wikipedia"),

                       UIImage(named:"evernote"),
                       UIImage(named:"wordpress"),
                       UIImage(named:"ted"),
                       UIImage(named:"github"),
                       UIImage(named:"swift")
                      ]

    //MARK :Default Config
    var defaultCodeColor = UIColor.black
    
    var defaultBgImage = UIImage()
    var defaultBgColor = UIColor.white
    var defaultIconImage = UIImage()
    
    
    lazy var collectionView :UICollectionView = {
    
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize.init(width: cellHeight, height: cellHeight)
        flow.scrollDirection = .horizontal
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 0;

        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flow)
        collectionView.backgroundColor = CODE_TABBAR_BGCOLOR
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true

        collectionView.register(QRCodeSkinCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
        
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QRCode Result".localized
        self.view.backgroundColor = APPCOLOR
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapActionButton(_:)))
        self.view.addSubview(codeBackView)
        let backWidth = UIScreen.main.bounds.width - 30
        codeBackView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width:backWidth,height:backWidth))
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(10 + UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!)
        }
        
        codeBackView.addSubview(codeImageView)
        
        codeImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
            make.top.equalToSuperview().offset(40)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        codeBackView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(codeBackView.snp.centerX)
            make.centerY.equalTo(codeBackView.snp.centerY)
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 0
        iconImageView.layer.borderWidth = 5
        iconImageView.layer.borderColor = UIColor.clear.cgColor
        
        iconImageView.isHidden = true
        
        self.setupSegmentView()
        self.setupCollectionView()
        self.setupAdView()

    }
    
    //MARK: - 生成最初图片
    public func setCodeImageViewImage(image: UIImage)
    {
        DispatchQueue.global().async {
            DispatchQueue.main.async(execute: {
                // Completion Handler
                self.codeImageView.image = image
                self.codeBackView.backgroundColor = UIColor(Hex: 0xffffff)
                
                DispatchQueue.global().asyncAfter(deadline: .now()+0.1, execute:
                {
                    let newImage = self.oldCodeImage.filterColor(withBackgroundColor: UIColor.clear, withQRCodeColor: self.defaultCodeColor)
                    DispatchQueue.main.async(execute: {
                        self.codeImageView.image = newImage
                    })
                })
            })
        }
        
        
    }
  
    private func setupSegmentView()
    {        
        let images = [UIImage(named: "genicon01"),UIImage(named: "genicon03"),UIImage(named: "genicon04")]
        segmentedControl.setSegmentImageItems(images as! [UIImage])
        segmentedControl.delegate = self
        
        self.view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(bottomViewHeight)
        }
    }


    fileprivate func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(segmentedControl.snp.top)
            make.height.equalTo(60)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let line = UIView()
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(-0.5)
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        line.backgroundColor = TIPSCOLOR
    }
    
    func setupAdView() {
            
        bannerView = GADBannerView.init()
        self.view.addSubview(bannerView)
        
        let request = GADRequest()
        let adId = "" //editcode
        
        bannerView.adUnitID = adId
        bannerView.rootViewController = self
        bannerView.load(request)
        
        bannerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
            make.height.equalTo(85)
        }
//        bannerView.isHidden = true
    }

    
    func didTapActionButton(_ sender: UIBarButtonItem)
    {
        let shareImage = codeBackView.screenShot()
        
        DispatchQueue.global().async {
            let recognizeResult = shareImage?.recognizeQRCode()
            
            let result = recognizeResult?.characters.count > 0 ? recognizeResult : "Unrecognized".localized
            DispatchQueue.main.async
                {
                    if result == "Unrecognized".localized
                    {
                        Tool.alertMessage(title: "Tips".localized(), message: "Similar failures".localized(), btn1Titile: "Cancel".localized(), btn2Title: "I Know".localized(), controller: self, handler: { (UIAlertAction) in
                            self.systemShare(image: shareImage)
                        })
                    }
                    else{
                        self.systemShare(image: shareImage)
                    }
            }
        }

        
    }
    
    
    private func systemShare(image: UIImage!)
    {
//        let imageData: NSData! = UIImagePNGRepresentation(myImage as UIImage!) as NSData!
        let activityViewController = UIActivityViewController(
            activityItems:  [image],
            applicationActivities: nil)
        if activityViewController.popoverPresentationController != nil {
            
        }
        present(activityViewController, animated: true, completion:nil)
        activityViewController.completionWithItemsHandler = {
            (str, done, items, error) in
            
            if str == .saveToCameraRoll {
                if done
                {
                    HUD.flash(.label("Save to library success".localized), delay: 1.5) { _ in}
                }
            }
        }
    }
    //MARK: -UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellHeight, height: cellHeight)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

    
    //MARK: -UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.selectIndex {
//        case 0:
//            return 5
        case 0:
            return self.codeColors.count
        case 1:
            return self.bgColors.count + self.bgImages.count
        case 2:
            return self.iconImages.count
        default:
            break
        }
        return 0
    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        switch self.selectIndex {
//        case 0:
//            (cell as! QRCodeSkinCell).imageView.backgroundColor = UIColor.init(Hex:0xff0000)
//            (cell as! QRCodeSkinCell).imageView.image = nil
//            (cell as! QRCodeSkinCell).layer.cornerRadius = 2
//            (cell as! QRCodeSkinCell).layer.masksToBounds = true

            
        case 0:
            (cell as! QRCodeSkinCell).imageView.backgroundColor = UIColor(Hex: codeColors[indexPath.row])
            (cell as! QRCodeSkinCell).imageView.image = nil
            (cell as! QRCodeSkinCell).layer.cornerRadius = CGFloat(cellHeight/2)
            (cell as! QRCodeSkinCell).layer.masksToBounds = true
            
        case 1 :
            (cell as! QRCodeSkinCell).layer.cornerRadius = 5
            (cell as! QRCodeSkinCell).layer.masksToBounds = true
            if indexPath.row < self.bgImages.count
            {
                (cell as! QRCodeSkinCell).imageView.image = self.bgImages[indexPath.row]
                (cell as! QRCodeSkinCell).imageView.backgroundColor = UIColor.clear
            }
            else
            {
                (cell as! QRCodeSkinCell).imageView.image = nil
                (cell as! QRCodeSkinCell).imageView.backgroundColor = UIColor.init(Hex: self.bgColors[indexPath.row-self.bgImages.count])
            }
            
        case 2:
            (cell as! QRCodeSkinCell).imageView.image = self.iconImages[indexPath.row]
            (cell as! QRCodeSkinCell).imageView.backgroundColor = UIColor.clear
            (cell as! QRCodeSkinCell).layer.cornerRadius = 0
            (cell as! QRCodeSkinCell).layer.masksToBounds = false

        default:
            break
        }
        return cell
    }
    
    //MARK: -UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch self.selectIndex {
//        case 0:
//            break
        case 0:
            self.changeCodeColor(newColor: UIColor.init(Hex: codeColors[indexPath.row]))
        case 1:
            if indexPath.row < self.bgImages.count
            {
                
                if indexPath.row == 0 {
                    Tool.shareTool.choosePicture(self, editor: true, options: .photoLibrary) {[weak self] (image) in
                        self?.codeBackView.backgroundColor = UIColor.clear
                        self?.codeBackView.image = image
                    }
                }
                else{
                    self.codeBackView.backgroundColor = UIColor.clear
                    self.codeBackView.image = self.bgImages[indexPath.row]
                }
            }
            else
            {
                self.codeBackView.image = nil
                self.codeBackView.backgroundColor =  UIColor.init(Hex: self.bgColors[indexPath.row-self.bgImages.count])
            }
        case 2:
            if indexPath.row == 0
            {
                self.iconImageView.isHidden = true
            }
            else if indexPath.row == 1
            {
                Tool.shareTool.choosePicture(self, editor: true, options: .photoLibrary) {[weak self] (image) in
                    self?.iconImageView.isHidden = false
                    self?.iconImageView.image = image
                }

            }
            else
            {
                self.iconImageView.isHidden = false
                self.iconImageView.image = self.iconImages[indexPath.row]
            }
        default:
            break
            
        }
    }
    
    func changeCodeColor(newColor : UIColor)
    {
//        SVProgressHUD.show()
//        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        DispatchQueue.global().async
        {
            let newImage = self.oldCodeImage.filterColor(withBackgroundColor: UIColor.clear, withQRCodeColor: newColor)
            DispatchQueue.main.async(execute: {
                self.codeImageView.image = newImage
//                SVProgressHUD.dismiss()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    SVProgressHUD.dismiss()
//                }
            })
        }
    }    
}

extension QRCodeViewController: TwicketSegmentedControlDelegate {
    func didSelect(_ segmentIndex: Int) {
        print("Selected idex: \(segmentIndex)")
        self.selectIndex = segmentIndex
        self.collectionView.reloadData()
        self.collectionView.contentOffset = CGPoint.init(x: 0, y: 0)
        
    }
}

