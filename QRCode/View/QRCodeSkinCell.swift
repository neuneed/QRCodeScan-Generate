//
//  QRCodeSkinCell.swift
//  QRCode
//
//  Created by Lee on 2016/11/13.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation
import QuartzCore


class QRCodeSkinCell: UICollectionViewCell {
    
    open var imageView = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
