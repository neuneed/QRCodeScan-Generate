//
//  UIView+ScreenShot.m
//  KingWeatherForIOS
//
//  Created by zhangnan on 16/4/26.
//  Copyright © 2016年 tianqiwang. All rights reserved.
//

#import "UIView+ScreenShot.h"


@implementation UIView (ScreenShot)

- (UIImage *)screenShot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale*1.5);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImg;
}






@end
