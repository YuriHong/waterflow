//
//  lieonShopCell.h
//  瀑布流
//
//  Created by 李仁军on 16/2/16.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import "lieonWaterflowCell.h"
#import "lieonWaterflowView.h"
#import "lieonShop.h"

@interface lieonShopCell : lieonWaterflowCell
/** 数据模型*/
@property(nonatomic,strong)  lieonShop * shop;

/**
 *  创建cell
 */
+ (instancetype)cellWithWaterflow:(lieonWaterflowView*)waterflowView;

@end
