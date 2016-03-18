//
//  UIImage+Image.m
//  微博
//
//  Created by 李仁军on 16/1/15.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import "UIImage+Image.h"

#warning 创建的UIImage的子类，在这里面写一个类方法。使图片不被渲染
@implementation UIImage (Image)
+(instancetype)imageWithRenderOriginalName:(NSString*)name
{
    UIImage * selImage = [UIImage imageNamed:name];
#warning 不让图片被渲染
    selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return selImage;
}

/**
 *  拉伸图片，宽高的一半不被拉伸，相当于9切片技术
 */

+(UIImage *)resizedImageWithName:(NSString*)name
{
    UIImage * image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    //开启基于图形的上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    //拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}
@end
