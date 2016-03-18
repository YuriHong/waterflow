//
//  lieonWaterflowView.m
//  瀑布流
//
//  Created by 李仁军on 16/2/15.
//  Copyright © 2016年 lieon. All rights reserved.
//

#import "lieonWaterflowView.h"


#define lieonWaterflowViewDefaultHeight 70
#define lieonWaterflowViewDefaultNumberOfColmns 3
#define lieonWaterflowViewDefaultMargin 8

@interface lieonWaterflowView()

/**
 *  存放cell的frame数据
 */
@property(nonatomic,strong) NSMutableArray *cellFrames;

/**
 *  存放已经存在的cell
 */
@property(nonatomic,strong)  NSMutableDictionary * displayingCells;

/**
 *  缓存池
 */
@property(nonatomic,strong) NSMutableSet * reusableCells;

@end
@implementation lieonWaterflowView

-(NSMutableArray *)cellFrames
{
    if(_cellFrames == nil)
    {
        _cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells
{
    if(_displayingCells == nil)
    {
        _displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

// 父控件即将显示时，刷新数据
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}
#pragma mark -- 公共接口
/*刷新数据
 * 1.计算每一个cell的frame
 */
-(void)reloadData
{
//    刷新数据之前，清空之前的所有数据
//    1.移除正在显示的cell
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCells removeAllObjects];
    
   NSUInteger numberOfCells = [self.dataSource numberOfCellsInWaterflow:self];
//   总列数
    NSUInteger numberOfColumns = [self numberOfColums];
    
// 间距
    CGFloat topM= [self marginForType:lieonWaterflowViewMarginTypeTop];
    CGFloat bottomM= [self marginForType:lieonWaterflowViewMarginTypeBottom];
    CGFloat leftM= [self marginForType:lieonWaterflowViewMarginTypeLeft];
    CGFloat columnM= [self marginForType:lieonWaterflowViewMarginTypeColumn];
    CGFloat rowM= [self marginForType:lieonWaterflowViewMarginTypeRow];
    
//    cell的宽度
    CGFloat cellW = [self cellWidth];
    
//    用一个C语言数组存放所有列的最大Y值
    CGFloat maxYOfColumns[numberOfColumns];

//    初始化数组
    for(int i = 0; i < numberOfColumns; i++)
    {
        maxYOfColumns[i] = 0.0;
    }
    
//    计算所有的cell的frame
  for (NSUInteger i = 0; i < numberOfCells; i++)
    {
        /**
         *  x和y的位置向上一次的最大的y值补齐
         */
        
        //记录cell处在第几列（最短的一列）
        NSUInteger cellColumn = 0;
        
        // cell所处那列的最大y值（最短那一列的最大y值）
        CGFloat maxYOfCellColumn = maxYOfColumns[cellColumn];
        
        //求出最短的一列
        for (int j = 1; j < numberOfColumns; j++) {
            if(maxYOfColumns[j] < maxYOfCellColumn)
            {
                cellColumn = j;
                maxYOfCellColumn = maxYOfColumns[j];
            }
        }

        //    询问代理第i个位置的cell的高度
       CGFloat cellH = [self heightAtIndex:i];
     
//        cell的位置
        CGFloat cellX = leftM + cellColumn * (cellW + columnM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0) { //
            cellY = topM;
        }else
        {
            cellY = maxYOfCellColumn + rowM;
        }
        
//        计算cell的frame
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        
//        将cell的frame放入数组中
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
       
//        更新最短那一列的最大y值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
        

        
    }
    
//    设置contentSize
    
    CGFloat contentH = maxYOfColumns[0];
    for(int j = 1 ; j < numberOfColumns ;j++)
    {
        if(maxYOfColumns[j] > contentH)
        {
            contentH = maxYOfColumns[j];
        }
    }
    contentH += bottomM;
    
    self.contentSize = CGSizeMake(0, contentH);
}

/**
 *  当UIScrollView滚动时也会调用这个方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
   //  问数据源要对应位置的cell
    NSUInteger  numberOfCells = self.cellFrames.count;
    for(int i = 0;i < numberOfCells;i++)
    {
//        取出对应位置的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
//     优先从字典中去出i位置的cell
        lieonWaterflowCell * cell = self.displayingCells[@(i)];
        
//        判断i位置对应的frame在不在屏幕上（能否看见）
        if([self isInScreen:cellFrame]) // 在屏幕上
        {
//        没有则向数据源要
            if(cell == nil)
            {
                cell = [self.dataSource waterflowView:self cellAtIndex:i];
                cell.frame = [self.cellFrames[i] CGRectValue];
                [self addSubview:cell];
                
//                存放到字典中
                self.displayingCells[@(i)] = cell;
            }
            
        }else //不在屏幕上
        {
            if(cell) //如果cell存在
            {
                
            // 从scrollView和字典中移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                
            // 添加到缓存池中
                [self.reusableCells addObject:cell];
            }
        }
    }
  
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block lieonWaterflowCell * reusableCell = nil;
    
//    遍历缓存池
    [self.reusableCells enumerateObjectsUsingBlock:^(lieonWaterflowCell* cell, BOOL * _Nonnull stop) {
        
        if([cell.identifier isEqualToString:identifier])
        {
            reusableCell = cell;
            *stop = YES;
        }
    }];
    if(reusableCell) // 从缓存池中移除
    {
        [self.reusableCells removeObject:reusableCell];
    }
    return  reusableCell;
}

- (CGFloat)cellWidth
{
    //   总列数
    NSUInteger numberOfColumns = [self numberOfColums];
    
    CGFloat leftM= [self marginForType:lieonWaterflowViewMarginTypeLeft];
    CGFloat rightM= [self marginForType:lieonWaterflowViewMarginTypeRight];
    CGFloat columnM= [self marginForType:lieonWaterflowViewMarginTypeColumn];
    
    CGFloat cellW = (self.bounds.size.width -leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
    return cellW;
}
#pragma mark -- 私有方法

/**
 *  判断一个frame有无显示在屏幕上
 */

- (BOOL)isInScreen:(CGRect)frame
{
    if((CGRectGetMaxY(frame) > self.contentOffset.y)&&(CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height))
    {
        return YES;
    }else
    {
        return  NO;
    }
}

/**
 *  高度
 */
- (CGFloat)heightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterflow:heightAtIndex:)]) {
        return [self.delegate waterflow:self heightAtIndex:index];
    }else
    {
        return lieonWaterflowViewDefaultHeight;
    }
}

/**
 *  总列数
 */
- (CGFloat)numberOfColums
{
    if([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterflow:)])
    {
        return [self.dataSource numberOfColumnsInWaterflow:self];
    }else
    {
        return lieonWaterflowViewDefaultNumberOfColmns;
    }
}

/**
 *  间距
 */
- (CGFloat)marginForType:(lieonWaterflowViewMarginType)type
{
    if([self.delegate respondsToSelector:@selector(waterflow:marginForType:)])
    {
     return   [self.delegate waterflow:self marginForType:type];
        
    }else
    {
        return lieonWaterflowViewDefaultMargin;
    }
}

#pragma mark -- 事件处理

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(![self.delegate respondsToSelector:@selector(waterflow:didSelectedAtIndex:)]) return;
    UITouch * touch  = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber * selectedIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, lieonWaterflowCell  * obj, BOOL * _Nonnull stop) {
        
        if(CGRectContainsPoint(obj.frame, point))
        {
            selectedIndex = key;
            *stop = YES;
        }
    }];
    
    if(selectedIndex)
    {
//        通知代理
        [self.delegate waterflow:self didSelectedAtIndex:[selectedIndex unsignedIntegerValue ]];
    }
}
@end
