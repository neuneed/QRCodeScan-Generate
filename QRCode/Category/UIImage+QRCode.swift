//
//  UIImage+QRCode.swift
//  QRCode
//
//  Created by gaofu on 16/9/9.
//  Copyright © 2016年 gaofu. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage
{
    /**
     1.识别图片二维码
     
     - returns: 二维码内容
     */
    func recognizeQRCode() -> String?
    {
        let context = CIContext(options:nil)

        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        guard let ciImage = CIImage(image: self) else {
            return nil
        }
        let features = detector?.features(in: ciImage)
        guard (features?.count)! > 0 else { return nil }
        let feature = features?.first as? CIQRCodeFeature
        return feature?.messageString!
    }
    
    
    //2.获取圆角图片
    func getRoundRectImage(size:CGFloat,radius:CGFloat) -> UIImage
    {
        return getRoundRectImage(size: size, radius: radius, borderWidth: nil, borderColor: nil)
    }
    
    
    //3.获取圆角图片(带边框)
    func getRoundRectImage(size:CGFloat,radius:CGFloat,borderWidth:CGFloat?,borderColor:UIColor?) -> UIImage
    {
        let scale = self.size.width / size ;
    
        //初始值
        var defaultBorderWidth : CGFloat = 0
        var defaultBorderColor = UIColor.clear
        
        if let borderWidth = borderWidth { defaultBorderWidth = borderWidth * scale }
        if let borderColor = borderColor { defaultBorderColor = borderColor }
        
        let radius = radius * scale
        let react = CGRect(x: defaultBorderWidth, y: defaultBorderWidth, width: self.size.width - 2 * defaultBorderWidth, height: self.size.height - 2 * defaultBorderWidth)
        
        //绘制图片设置
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let path = UIBezierPath(roundedRect:react , cornerRadius: radius)
        
        //绘制边框
        path.lineWidth = defaultBorderWidth
        defaultBorderColor.setStroke()
        path.stroke()

        path.addClip()
        
        //画图片
        draw(in: react)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!;
    }
    
    
    func addCenterImage(logo:UIImage) -> UIImage
    {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        logo .draw(in: CGRect.init(x: (self.size.width * 0.8) * 0.5, y: (self.size.height * 0.8) * 0.5, width: self.size.width * 0.2, height: self.size.height * 0.2))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
//    func imageOfRoundRectWithImage(iconImage : UIImage) -> UIImage {
//        let width = iconImage.size.width
//        let height = iconImage.size.height
//        var radius = 5
//        
//        radius = max(5, radius)
//        radius = min(10, radius)
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
//
//        let rect = CGRect.init(x:0 , y:0 , width:width , height: height)
//        
//        context.draw(iconImage.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: width ,height: height))
//  
//        return UIImage()
//    }
}

