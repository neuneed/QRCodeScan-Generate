//
//  OpenSourceViewController.swift
//  QRCode
//
//  Created by Lee on 2016/11/6.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation
import UIKit
import JSQWebViewController


class OpenSourceViewController :UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView: UITableView! = UITableView.init()
    
    let sectionTitle = ["💡Thanks To💡".localized]
    let rowTitle01 = ["SnapKit","PKHUD","SwiftyUserDefaults","JSQWebViewController","Segmentio"]
    let rowSubTitle = ["@SnapKit","@pkluz","@radex","@jessesquires","@Yalantis"]
    
    let rowUrl = ["https://github.com/SnapKit/SnapKit/blob/develop/README.md", "https://github.com/pkluz/PKHUD/blob/master/README.md", "https://github.com/radex/SwiftyUserDefaults/blob/master/README.md", "https://github.com/jessesquires/JSQWebViewController/blob/develop/README.md","https://github.com/Yalantis/Segmentio"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(Hex: 0xEAEEF1)
        self.title = "OpenSource".localized()
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.backgroundColor = UIColor(Hex: 0xEAEEF1)
        tableView.dataSource = self
        tableView.frame = self.view.frame
        tableView.isScrollEnabled = false
        
        let footContain = UIView.init()
        footContain.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        let footView = UIImageView.init(image: #imageLiteral(resourceName: "icon_name"))
        footView.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width, height: 25)
        footView.contentMode = .scaleAspectFit
        footContain.addSubview(footView)
        tableView.tableFooterView = footContain
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return rowTitle01.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: nil)
        let row = indexPath.row as Int
        cell.textLabel?.text =  rowTitle01[row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.accessoryType = .disclosureIndicator
        
        cell.detailTextLabel?.text = rowSubTitle[row]
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 12)
        cell.detailTextLabel?.textColor = UIColor.init(Hex: 0x8898B3)
        cell.detailTextLabel?.textAlignment = .right
        return cell
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
            make.left.equalToSuperview().offset(0)
        }
        sectionLabel.textAlignment = .center
        
        return sectionView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = WebViewController(url: URL(string: rowUrl[indexPath.row] as String!)!)
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
        
    }
    
    
    
}


