//
//  UIBarButtonItem+Extension.m
//  微博
//
//  Created by 李仁军on 16/1/15.
//  Copyright © 2016年 lieon. All rights reserved.
//

#warning categort下的文件夹都可以移植
#import "UIBarButtonItem+Extension.h"

#warning 创建 UIBarButtonItem的一个分类，在分类中增加一个方法 (封装的思想)

/**
 *  创建 UIBarButtonItem的一个分类，在分类中增加一个方法
 */
@implementation UIBarButtonItem (Extension)

+(UIBarButtonItem*)ItemWithBackGroundImage:(NSString*)image hilghtedBackGroundImage:(NSString*)hightImage target:(id)target action:(SEL)action
{
    UIButton * btn= [UIButton new];
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState: UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hightImage]forState:UIControlStateHighlighted];
#warning  设置按钮的size为它的背景图片的大小
    //    btn.bounds= CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
#warning
    [btn sizeToFit];
    //    监听按钮的点击
#warning UIControlEventTouchDown比UIControlEventTouchUpInside响应慢
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}

+(UIBarButtonItem*)ItemWithBackGroundImage:(NSString*)image target:(id)target action:(SEL)action
{
    UIButton * btn= [UIButton new];
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState: UIControlStateNormal];
    
#warning  设置按钮的size为它的背景图片的大小
    //    btn.bounds= CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
#warning
    [btn sizeToFit];
    //    监听按钮的点击
#warning UIControlEventTouchDown比UIControlEventTouchUpInside响应慢
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end
