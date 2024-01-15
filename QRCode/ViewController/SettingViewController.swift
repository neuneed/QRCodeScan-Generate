//
//  ViewController.swift
//  QRCode
//
//  Created by Lee on 2016/10/26.
//  Copyright © 2016 dotc. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import MessageUI

class SettingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,switchViewDelegate ,MFMailComposeViewControllerDelegate{

//    1251497563 id
    var tableView: UITableView!
    let sectionTitle = ["General".localized,"More".localized,"About".localized]
    let rowTitle01 = ["BrowserInApp".localized,"CheakSafe".localized,"ClearHistory".localized] //Word Stemming 
    let rowTitle02 = ["ContactUs".localized,"RateUs".localized]
    let rowTitle03 = ["Version".localized,"OpenSource".localized]
    //image
    let setionImages1 = ["browser","safe_cheak","clear"]
    let setionImages2 = ["contact_us","rate_us"]
    let setionImages3 = ["version","open_source"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = APPCOLOR
        self.title = "Setting".localized
        
        tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.frame = self.view.frame
        tableView.backgroundColor = APPCOLOR
        
//        tableView.tableFooterView = UIView()
        
        let footContain = UIView.init()
        footContain.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        let footView = UIImageView.init(image: #imageLiteral(resourceName: "icon_name"))
        footView.frame = CGRect.init(x: 0, y: 15, width: self.view.frame.size.width, height: 25)
        footView.contentMode = .scaleAspectFit
        footContain.addSubview(footView)
        tableView.tableFooterView = footContain
        tableView.sectionFooterHeight = 0.0

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return rowTitle01.count
        case 1:
            return rowTitle02.count
        case 2:
            return rowTitle03.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row as Int
        let section = indexPath.section as Int
        
        let newCell = SettingViewCell.init(style: .default, reuseIdentifier: nil)
        switch section {
        case 0:
            newCell.title.text =  rowTitle01[row]
            newCell.iconView.image = UIImage.init(named: setionImages1[row])
            if row == 2
            {
                newCell.switchView.isHidden = true
            }
            else
            {
                if row == 0
                {
                   newCell.delegate = self
                   newCell.switchView.isOn = Defaults[.openInSafari]!
                }
                else if row == 1
                {
                    newCell.delegate = nil
                    newCell.switchView.isOn = false
                    newCell.switchView.isUserInteractionEnabled = false
                }
                
                newCell.selectionStyle = .none
            }
            
        case 1:
            newCell.title.text =  rowTitle02[row]
            newCell.iconView.image = UIImage.init(named: setionImages2[row])
            newCell.switchView.isHidden = true

        case 2:
            newCell.title.text =  rowTitle03[row]
            newCell.iconView.image = UIImage.init(named: setionImages3[row])
            newCell.switchView.isHidden = true
            if row == 0
            {
                newCell.subTitle.isHidden = false
                newCell.subTitle.text = versionBuild() as String!
                newCell.selectionStyle = .none
            }
        default:
            break
        }
    
        return newCell;
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionView = UIView()
        sectionView.backgroundColor = APPCOLOR
        
        let sectionLabel = UILabel()
        sectionLabel.backgroundColor = UIColor.clear
        sectionLabel.text = sectionTitle[section].uppercased()
        sectionLabel.textAlignment = .left
        sectionLabel.font = UIFont.init(name: "HelveticaNeue-Light", size: 13)
        sectionLabel.textColor = UIColor.init(Hex: 0x888888)
        sectionView.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row as Int
        let section = indexPath.section as Int
        print("did selected")
        
        if section == 0
        {
            if row == 2
            {
                Tool.alertMessage(title: "Are you sure?".localized(), message: "Will clear all your local history.".localized(), btn1Titile: "Cancel".localized(), btn2Title: "Sure".localized(), controller: self, handler: { (UIAlertAction) in
                    
                    let isSuccess = clearAllHistory()
                    if isSuccess {
                        Tool.confirm(title: "Tips".localized, message: "Clear History Success".localized, controller: self)
                    }
                    else{
                        Tool.confirm(title: "Tips".localized, message: "Something wrong".localized, controller: self)
                    }
                    HistoryViewController().reloadListData()
                })
            }
        }
        else if section == 1
        {
            if row == 0 {
                sentEmail()
//                print("send email")
            }
            else if row == 1{
    
                let url = NSURL(string: "https://itunes.apple.com/us/app/id1251497563")
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            }
        }
        else if section == 2
        {
            if row == 1
            {
                let openSourceVC = OpenSourceViewController()
                openSourceVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(openSourceVC, animated: true)
            }
        }
    }

    //MARK: - switchViewDelegate
    func switchAction(isON: Bool){
        Defaults[.openInSafari] = isON
    }
    
    func sentEmail(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["neuneed@gmail.com"])
        mailComposerVC.setSubject("Feedback".localized())
        
        let vString = appVersion()
        let message   = "For: Colorful And Fun QRCode App. Version:\(vString)"
        mailComposerVC.setMessageBody(message, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email".localized(), message: "Your device could not send e-mail.  Please check e-mail configuration and try again.".localized(), delegate: self, cancelButtonTitle: "OK".localized())
        sendMailErrorAlert.show()
    }
    
    
    //MARK: --MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    

}

