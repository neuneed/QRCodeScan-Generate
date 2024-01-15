//
//  SettingViewCell.swift
//  QRCode
//
//  Created by Lee on 2016/11/4.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation
import UIKit


protocol switchViewDelegate
{
    func switchAction(isON: Bool)
}

class SettingViewCell: UITableViewCell {
    
    let iconView = UIImageView()
    let title = UILabel()
    let switchView = UISwitch()
    let subTitle = UILabel()
    var delegate:switchViewDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews()
    {
        self.addSubview(iconView)
        self.addSubview(title)
        self.addSubview(switchView)
        self.addSubview(subTitle)
        
        title.font = UIFont.systemFont(ofSize: 14)
        let height = self.frame.size.height
        
        iconView.snp.makeConstraints { (make) in
            make.height.equalTo(height-15)
            make.width.equalTo(height-15)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-80)
        }
        
        switchView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(50)
            make.centerY.equalToSuperview()
            make.height.equalTo(height-15)
        }
        switchView.addTarget(self, action: #selector(switchOnOff), for: .touchUpInside)
        switchView.onTintColor = TIPSCOLOR
        
        
        subTitle.isHidden = true
        subTitle.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-13)
            make.left.equalTo(title.snp.right).offset(-40)
            make.centerY.equalToSuperview()
            make.height.equalTo(height-15)
        }
        subTitle.font = UIFont.italicSystemFont(ofSize: 14)
        subTitle.textColor = UIColor.init(Hex: 0x8898B3)
        subTitle.textAlignment = .right
    }

    func switchOnOff()
    {
        self.delegate?.switchAction(isON: switchView.isOn)
    }
    
}
