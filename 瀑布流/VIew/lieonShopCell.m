//
//  lieonShopCell.m
//  瀑布流
//
//  Created by 李仁军on 16/2/16.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import "lieonShopCell.h"
#import "UIImageView+WebCache.h"

@interface lieonShopCell()
@property(nonatomic,weak) UIImageView * imageView;
@property(nonatomic,weak) UILabel * priceLabel;

@end
@implementation lieonShopCell

+ (instancetype)cellWithWaterflow:(lieonWaterflowView *)waterflowView
{
    static NSString *identifier = @"cell";
    
    lieonShopCell * cell = [waterflowView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[lieonShopCell alloc]init];
        cell.identifier = identifier;
        
    }
    
    return cell;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
//        创建图片view
        UIImageView * imageView = [[UIImageView alloc]init];
        [self addSubview: imageView];
        self.imageView = imageView;
        
        UILabel * label = [[UILabel alloc]init];
//        给label设置一个透明的背景色，但是字体不会变透明
        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        self.priceLabel = label;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.height - priceH;
    CGFloat priceW = self.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
    
}

- (void)setShop:(lieonShop *)shop
{
    _shop = shop;
    self.priceLabel.text  = shop.price;
    [ self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:nil];
}
@end
