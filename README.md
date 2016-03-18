# waterflow 
#仿照的tableView的底层设计的
#大致用法与tableView类似
#cell里面的视图可自定义
#具体用法详见Demo!
##数据源方法和代理方法
**  数据源方法*/
@protocol lieonWaterflowViewDataSource <NSObject>

@required

/**  一个有多少个数据 */
- (NSUInteger)numberOfCellsInWaterflow:(lieonWaterflowView*)waterflow;

/**   返回对应位置的cell */
- (lieonWaterflowCell*)waterflowView:(lieonWaterflowView*)waterflowView cellAtIndex:(NSUInteger)index;

@optional
/**  一共有多少列 */
- (NSUInteger)numberOfColumnsInWaterflow:(lieonWaterflowView*)waterflowView;

@end

/** 代理方法*/
@protocol lieonWaterflowViewDelegate <UIScrollViewDelegate>

@optional

/** 第index位置对应的高度 */
- (CGFloat)waterflow:(lieonWaterflowView*)waterflowView heightAtIndex:(NSUInteger)index;

/**  选中第index位置的cell */
- (void)waterflow:(lieonWaterflowView*)waterflowView didSelectedAtIndex:(NSUInteger)index;

/** 返回间距lieonWaterflowViewMarginType;*/
- (CGFloat)waterflow:(lieonWaterflowView*)waterflowView marginForType:(lieonWaterflowViewMarginType)type;

@end


@interface lieonWaterflowView : UIScrollView
// 数据源
@property(nonatomic,weak) id<lieonWaterflowViewDataSource> dataSource;
//代理
@property(nonatomic,weak) id <lieonWaterflowViewDelegate> delegate;

## 公共接口
/** 刷新数据(主要调用这个方法，会重新向数据源和代理刷新数据)*/
- (void)reloadData;

/** 根据标示去缓存池中取可重用的cell */
- (id)dequeueReusableCellWithIdentifier:(NSString*)identifier;

/** cell的宽度 */
- (CGFloat)cellWidth;

@end

