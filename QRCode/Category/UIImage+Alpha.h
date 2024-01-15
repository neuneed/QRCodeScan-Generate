//
//  UIImage+Alpha.h
//  QRCode
//
//  Created by Lee on 2016/11/6.
//  Copyright © 2016年 dotc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Alpha)
    
- (UIImage *)setToAlpha;
- (UIImage *)filterColor;
    
- (UIImage *)filterColorWithBackgroundColor :(UIColor*)backgroundColor withQRCodeColor:(UIColor *)QRCodeColor;

    
@end
