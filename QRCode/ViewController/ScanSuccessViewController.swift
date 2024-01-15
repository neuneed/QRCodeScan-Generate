//
//  ScanSuccessViewController.swift
//  QRCode
//
//  Created by Lee on 2016/11/1.
//  Copyright © 2016 dotc. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PKHUD
import JSQWebViewController
import SwiftyUserDefaults



class ScanSuccessViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource,UITextViewDelegate{

    var topBgView = UIView()
    public var contentView = UILabel()
    var countLabel = UILabel()
    var tableView: UITableView! = UITableView.init(frame: CGRect.init(), style: .grouped)
    @IBOutlet var bannerView: GADBannerView!
    
    let sectionTitle = ["Actions".localized,"More".localized]
    let rowTitle01 = ["Open in safari".localized,"Copy to clipboard".localized,"Search".localized,"Edit or Generate".localized]
    let rowTitle02 = ["Share".localized]
    let icons = [#imageLiteral(resourceName: "safari"),#imageLiteral(resourceName: "copy"),#imageLiteral(resourceName: "search"),#imageLiteral(resourceName: "edit"),#imageLiteral(resourceName: "share")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Code infomation".localized()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backItemClick(_:)))
        
        setUpViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpViews() {
        self.view.backgroundColor = APPCOLOR
        tableView.backgroundColor = APPCOLOR
        
        
        self.view.addSubview(topBgView)
        topBgView.backgroundColor = UIColor.init(Hex: 0x282828)
        topBgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(230)
        }
        
        topBgView.addSubview(contentView)
        contentView.backgroundColor = UIColor.clear
        contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        contentView.textAlignment = .left
        contentView.textColor = UIColor.white
        contentView.font = UIFont.systemFont(ofSize: 15)
        contentView.sizeToFit()
        contentView.numberOfLines = 0

        topBgView.addSubview(countLabel)
        countLabel.numberOfLines = 2
        countLabel.font = UIFont.italicSystemFont(ofSize: 10)
        countLabel.textColor = UIColor.init(Hex: 0x99A1A7)
        countLabel.textAlignment = .right
        countLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(25)
            make.width.equalTo(60)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.sectionFooterHeight = 0.0
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-50)
            make.top.equalTo(self.topBgView.snp.bottom)
        }

        bannerView = GADBannerView.init()
        self.view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let request = GADRequest()
        let adId = "" //banner TO DO
        
        bannerView.adUnitID = adId
        bannerView.rootViewController = self
        bannerView.load(request)
        self.view.bringSubview(toFront: bannerView)
//        bannerView.isHidden = true
    }
    
    public func setMessage(text: String!)
    {
        self.contentView.text = text
        self.contentView.sizeToFit()
        self.contentView.center = self.topBgView.center
        
        let count = text.length
        countLabel.text = "length:".localized() + "\(count)"
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return rowTitle01.count
        }
        else
        {
            return rowTitle02.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize:16)
        cell.textLabel?.textColor = UIColor.init(Hex: 0x333333)
        switch indexPath.section  {
        case 0:
            cell.textLabel?.text = rowTitle01[indexPath.row]
            cell.imageView?.image = icons[indexPath.row]
        case 1:
            cell.textLabel?.text = rowTitle02[indexPath.row]
            cell.imageView?.image = icons[indexPath.row + rowTitle01.count]
        default:
            break
        }

        return cell
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionView = UILabel.init()
        sectionView.text = sectionTitle[section]
        sectionView.textAlignment = .center
        sectionView.backgroundColor = UIColor.clear
        sectionView.textColor = UIColor.init(Hex: 0x99A1A7)
        sectionView.font = UIFont.systemFont(ofSize: 16)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let rowTitle01 = ["Open in safari".localized,"Copy to clipboard".localized,"Search".localized,"Edit or Generate".localized]
//        let rowTitle02 = ["Share".localized,"Save history".localized]
        
        let message = self.contentView.text
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                self.safariHandle(textMessage: message)
            }
            else if indexPath.row == 1 {
                self.copyToClipboard(textMessage: message)
            }
            else if indexPath.row == 2 {
                self.safariHandle(textMessage: message)
            }
            else if indexPath.row == 3 {
                self.goToCodeEditViewController()
            }
        }
        else if(indexPath.section == 1)
        {
            if indexPath.row == 0 {
                self.systemShare(textMessage: message)
            }
            else if indexPath.row == 1 {
               
            }
        }
    
    }
    
    
    //MARK: -UITextViewDelegate
    func backItemClick(_ sender:UIBarButtonItem){
        
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
    }
    
    private func copyToClipboard(textMessage : String?) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = textMessage
        HUD.flash(.label("Copy to clipboard success.".localized), delay: 1.5) { _ in
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
        }
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
            let newUrlForGoogle = "Search_url".localized() + ecodingStr!
            UIApplication.shared.openURL(NSURL(string:newUrlForGoogle)! as URL)
        }
    }
    
    func goToCodeEditViewController() {
            let genVC =  GenerateQRCodeViewController()
            genVC.initWithText(text:self.contentView.text!)
            genVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(genVC, animated: true)
    }


}

