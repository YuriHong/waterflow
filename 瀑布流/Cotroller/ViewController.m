//
//  ViewController.m
//  瀑布流
//
//  Created by 李仁军on 16/2/15.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import "ViewController.h"
#import "lieonWaterflowCell.h"
#import "lieonWaterflowView.h"
#import "lieonShopCell.h"
#import "lieonShop.h"
#import "MJRefresh.h"


@interface ViewController ()<lieonWaterflowViewDelegate,lieonWaterflowViewDataSource>
@property(nonatomic,strong)  NSMutableArray * shops;

@property(nonatomic,strong) lieonWaterflowView * waterflowView;
@end

@implementation ViewController

- (NSMutableArray *)shops
{
    if(_shops == nil)
    {
        NSArray * newShops = [lieonShop objectArrayWithFilename:@"1.plist"];
        
        _shops = [NSMutableArray arrayWithArray:newShops];
    }
    return _shops;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    lieonWaterflowView * waterflow = [[lieonWaterflowView alloc]init];
    waterflow.frame = self.view.bounds;
//    设置waterflow的宽高可自由拉伸，即跟随着父控件的尺寸自由伸缩
    waterflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    waterflow.dataSource = self;
    waterflow.delegate = self;
    [self.view addSubview:waterflow];
    self.waterflowView = waterflow;

//    添加刷新控件
    self.waterflowView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDatas)];
    self.waterflowView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDatas)];
}

//横屏再次刷新数据，重新计算cell的frame，必须设置对应view的宽高可拉伸 ，即跟随着父控件的尺寸自由伸缩waterflow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.waterflowView reloadData];
}

- (void)loadNewDatas
{
    
//    加载plist
    NSArray * newShops = [lieonShop objectArrayWithFilename:@"3.plist"];
    
    [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
   
    
//    刷瀑布流控件
    [self.waterflowView reloadData];
    
    [self.waterflowView.mj_header endRefreshing];
    
    
    
}

- (void)loadMoreDatas
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //    加载plist
        NSArray * newShops = [lieonShop objectArrayWithFilename:@"2.plist"];
        
        [self.shops addObjectsFromArray:newShops];
        
        //    刷瀑布流控件
        [self.waterflowView reloadData];
        
        [self.waterflowView.mj_footer endRefreshing];
    });
}
#pragma  mark -- 数据源方法
- (NSUInteger)numberOfCellsInWaterflow:(lieonWaterflowView *)waterflow
{
    return self.shops.count;
}

- (NSUInteger)numberOfColumnsInWaterflow:(lieonWaterflowView *)waterflowView

{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) { // 竖屏
        return 3;
    }else // 横屏
    {
        return 5;
    }
}

- (lieonWaterflowCell *)waterflowView:(lieonWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
    lieonShopCell * cell = [lieonShopCell cellWithWaterflow:waterflowView];
    cell.shop = self.shops[index];
    
    return cell;
}


#pragma mark -- 代理方法
- (CGFloat)waterflow:(lieonWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    lieonShop * shop = self.shops[index];
    
//    根据cell的宽度 和图片的宽高比，返回cell的高度
    return ((waterflowView.cellWidth )* [shop.h intValue] /[shop.w intValue]);
}

-(CGFloat)waterflow:(lieonWaterflowView *)waterflowView marginForType:(lieonWaterflowViewMarginType)type
{
    switch (type) {
        case lieonWaterflowViewMarginTypeBottom:
            return  1;
        case lieonWaterflowViewMarginTypeColumn:
            return  2;
            
        case lieonWaterflowViewMarginTypeLeft:
            return  3;
        case lieonWaterflowViewMarginTypeRight:
            return  1;
        case lieonWaterflowViewMarginTypeRow:
            return  5;
        case lieonWaterflowViewMarginTypeTop:
            return  7;
    }
}

- (void)waterflow:(lieonWaterflowView *)waterflowView didSelectedAtIndex:(NSUInteger)index
{
    NSLog(@"点击了第几%lu个cell",index);
}
@end
