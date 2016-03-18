//
//  lieonShop.h
//  瀑布流
//
//  Created by 李仁军on 16/2/16.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lieonShop : NSObject
/**
 *  价格
 */
@property(nonatomic,copy) NSString* price;
/**
 *  图片链接
 */
@property(nonatomic,copy) NSString* img;
/**
 *  图片宽度
 */
@property (nonatomic,assign)  NSNumber* w;
/**
 *  图片高度
 */
@property (nonatomic,assign)  NSNumber * h;
@end
