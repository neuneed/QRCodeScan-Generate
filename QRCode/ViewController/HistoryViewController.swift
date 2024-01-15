//
//  HistoryCodeViewController.swift
//  QRCode
//
//  Created by Lee on 2016/11/2.
//  Copyright © 2016 dotc. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HistoryViewController :UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    let cellReuseIdentifier = "historyCell"
    var tableView: UITableView! = UITableView()
    let nothingView = UIImageView.init()
    /// The banner view.
    @IBOutlet var bannerView: GADBannerView!
    
    
    
    var historyData = Array<Any>()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = APPCOLOR
        tableView.backgroundColor = APPCOLOR
        tableView.register(HistoryCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        self.title = "History".localized()
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-50)
            make.top.equalToSuperview()
        }

        nothingView.image = #imageLiteral(resourceName: "nothing_here")
        nothingView.contentMode = .scaleAspectFit
        self.view.addSubview(nothingView)
        nothingView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
            
        bannerView = GADBannerView.init()
        self.view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.tabBarController!.tabBar.frame.size.height)
//            make.width.equalTo(320);
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let request = GADRequest()
        let adId = "" //banner
    
        bannerView.adUnitID = adId
        bannerView.rootViewController = self
        bannerView.load(request)
        self.view.bringSubview(toFront: bannerView)
//        bannerView.isHidden = true
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nothingView.isHidden = getData()
        tableView.isHidden = !nothingView.isHidden
        tableView.reloadData()
//        bannerView.load(GADRequest())
    }
    
    func getData()  -> Bool{
        let data = getTheLocal()

        if data.count==0 {
            self.historyData = []
            return false
        }
        else{
            self.historyData = data
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row as Int
        let cell = HistoryCell.init(style: .default, reuseIdentifier: cellReuseIdentifier)
                
        let dictResult: NSDictionary = self.historyData[row] as! NSDictionary
        cell.setCellDataWith(Dict: dictResult)

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            historyData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reSaveData(newData: historyData)
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let dictResult: NSDictionary = self.historyData[indexPath.row] as! NSDictionary
        let genVC =  GenerateQRCodeViewController()
        genVC.initWithText(text:(dictResult.object(forKey: defaultText) as? String)!)
        genVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(genVC, animated: true)
    }
    
    public func reloadListData()
    {
        self.tableView.reloadData()
    }
    
}
