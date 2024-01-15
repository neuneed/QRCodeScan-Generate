//
//  PopViewController.swift
//  QRCode
//
//  Created by sidechef on 2017/6/4.
//  Copyright © 2017年 dotc. All rights reserved.
//

import Foundation

enum PopViewType{
    case left
    case center
    case right
}

let RowHeight:CGFloat = 44

var dataSource = ["Share","Copy","Open in Safari","Search"]


/**
 *  popView展现位置的代理
 */
protocol PopViewControllerDelegate:NSObjectProtocol{
    func didClickedPopButton(_ type:PopViewType)
}

/**
 *  popViewCell选择的代理
 */
protocol DidSelectPopViewCellDelegate:NSObjectProtocol{
    func didSelectRowAtIndexPath(_ indexPath: IndexPath)
}



class PopViewController:  UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var myTableView = UITableView()
    
    var popType:PopViewType?
    
    weak var delegate:PopViewControllerDelegate?
    
    weak var selectDelegate:DidSelectPopViewCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(popType!)
    }
    
    
    func setupViews(_ popViewtype:PopViewType) {
        var imgStr = ""
        switch popViewtype{
        case .left:
            imgStr = "popover_background_left"
        case .center:
            imgStr = "popover_background_center"
        default:
            imgStr = "popover_background_right"
        }
        let img = UIImage(named: imgStr)
        let imgView = UIImageView(image: img)
        imgView.frame.size = CGSize(width: 130, height: 170)
        view.addSubview(imgView)
        myTableView.frame = CGRect(x: 10, y: 17, width: 110, height: 140)
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
    }
}


extension PopViewController{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return RowHeight
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectDelegate?.didSelectRowAtIndexPath(indexPath)
    }
    
}
