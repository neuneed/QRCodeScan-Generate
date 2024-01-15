//
//  HistoryCell.swift
//  QRCode
//
//  Created by sidechef on 2017/5/21.
//  Copyright © 2017年 dotc. All rights reserved.
//

import Foundation

class HistoryCell: UITableViewCell {
    
    let title = UILabel()
    let subTitle = UILabel()
    let subCode = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews()
    {
        self.addSubview(title)
        self.addSubview(subTitle)
        self.addSubview(subCode)
        
        title.font = UIFont.systemFont(ofSize: 14)
        title.numberOfLines = 0

        title.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(15)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalToSuperview().offset(-85)
        }
        
        subTitle.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.left.equalTo(title.snp.right).offset(10)
            make.bottom.equalTo(self).offset(-3)
            make.height.equalTo(25)
        }
        subTitle.numberOfLines = 2
        subTitle.font = UIFont.italicSystemFont(ofSize: 9.5)
        subTitle.textColor = UIColor.init(Hex: 0x8898B3)
        subTitle.textAlignment = .right
        
        subCode.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(35)
            make.top.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-8)
        }
    }

    public func setCellDataWith(Dict: NSDictionary!)
    {
        
        let titleText = Dict.object(forKey: defaultText) as? String
        title.text = titleText
        let datef = Dict.object(forKey: defaultTime) as? Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dataformatestring".localized()
        let myString = formatter.string(from: datef!)
        subTitle.text = myString
                
        var image  = UIImage()
        DispatchQueue.global().async {
            image = (titleText?.generateQRCode())!
            DispatchQueue.main.async(execute: {
                UIView.transition(with: self.subCode,
                                  duration: 0.1,
                                  options: .transitionCrossDissolve,
                                  animations: {self.subCode.image = image },
                                  completion: nil)
                
            })
        }
 
    }
    
    
}
