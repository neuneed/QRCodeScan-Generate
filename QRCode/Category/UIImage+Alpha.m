//
//  UIImage+Alpha.m
//  QRCode
//
//  Created by Lee on 2016/11/6.
//  Copyright © 2016年 dotc. All rights reserved.
//

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)

- (UIImage *)setToAlpha
{
    UIImage *entryImage  = self;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage * ciImage = [CIImage imageWithCGImage:entryImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CIImage *result = [filter outputImage];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:[entryImage scale] orientation:UIImageOrientationUp];
    return newImage;
}


    
-(UIImage *)filterColor
{
    return [self filterColorWithBackgroundColor:[UIColor clearColor] withQRCodeColor:[UIColor blackColor]];
}

- (UIImage *)filterColorWithBackgroundColor :(UIColor*)backgroundColor withQRCodeColor:(UIColor *)QRCodeColor
{
    UIImage *entryImage  = self;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage * ciImage = [CIImage imageWithCGImage:entryImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
    [filter setDefaults];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    
    [filter setValue:[CIColor colorWithCGColor:QRCodeColor.CGColor] forKey:@"inputColor0"]; //二维码颜色
    [filter setValue:[CIColor colorWithCGColor:backgroundColor.CGColor] forKey:@"inputColor1"]; //背景颜色
    CIImage *result = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:[entryImage scale] orientation:UIImageOrientationUp];
    return newImage;
}



@end
