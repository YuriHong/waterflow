//
//  UIImage+Image.h
//  微博
//
//  Created by 李仁军on 16/1/15.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)
/**
 * 加载最原始的图片，使其没有渲染
 */
+(instancetype)imageWithRenderOriginalName:(NSString*)name;

+(UIImage *)resizedImageWithName:(NSString*)name;

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
@end
