//
//  UIBarButtonItem+Extension.h
//  微博
//
//  Created by 李仁军on 16/1/15.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(UIBarButtonItem*)ItemWithBackGroundImage:(NSString*)image hilghtedBackGroundImage:(NSString*)hightImage target:(id)target action:(SEL)action;
+(UIBarButtonItem*)ItemWithBackGroundImage:(NSString*)image target:(id)target action:(SEL)action;


@end
