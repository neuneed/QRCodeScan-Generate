//
//  UIImage+AddLogo.swift
//  QRCode
//
//  Created by Lee on 2016/11/6.
//  Copyright © 2016年 dotc. All rights reserved.
//

import Foundation

extension UIImage{

    //MARK:-- LOGO
    func generateQRCode(size:CGFloat?,color:UIColor?,bgColor:UIColor?,logo:UIImage?,radius:CGFloat,borderLineWidth:CGFloat?,borderLineColor:UIColor?,boderWidth:CGFloat?,borderColor:UIColor?) -> UIImage
    {
        guard let QRCodeLogo = logo else { return self }
        
        let logoWidth = self.size.width/4
        let logoFrame = CGRect(x: (self.size.width - logoWidth) /  2, y: (self.size.width - logoWidth) / 2, width: logoWidth, height: logoWidth)
        
        // 绘制logo
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        //线框
        let logoBorderLineImagae = QRCodeLogo.getRoundRectImage(size: logoWidth, radius: radius, borderWidth: borderLineWidth, borderColor: borderLineColor)
        //边框
        let logoBorderImagae = logoBorderLineImagae.getRoundRectImage(size: logoWidth, radius: radius, borderWidth: boderWidth, borderColor: borderColor)
        
        logoBorderImagae.draw(in: logoFrame)
        
        let QRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return QRCodeImage!
    }
    
    
    
}
