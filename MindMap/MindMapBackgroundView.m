//
//  MindMapBackgroundView.m
//  MindMap
//
//  Created by Kevin on 15/3/20.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import "MindMapBackgroundView.h"

@interface MindMapBackgroundView ()
{
    NSMutableArray *nodePositionArray;
}

@end

@implementation MindMapBackgroundView

@synthesize mindMapViewManager;

#pragma mark -
#pragma mark - Super Mehthods

/**
 *  此方法对于该类的对象进行绘制，需在设置了该对象飞Frame之后才会调用此方法,不可手动调用此方法
 *  调用setNeedsDisplay或者setNeedDisplayInRect方法会调用此地方法
 *
 *  @param rect self.frame范围内进行绘制
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //获取绘画句柄
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制节点之间的线条
    [self drawerLinesByTraverseNodePositionArrayWithArray:nodePositionArray andCGContextRef:context];
}

#pragma mark -
#pragma mark - Init Methods

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        nodePositionArray = [[NSMutableArray alloc] init];
        
        self.clearsContextBeforeDrawing = NO;
        self.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];
        
        //初始化绘图监听
        [self initializeLineNotificationToSelf];
        
        //初始化思维导图
        [self initializeMindMapView];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Public Methods

/**
 *  清除监听
 */
- (void)removeAllDrawNotifications
{
    //移除绘制线条监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DrawLinesToView" object:nil];
    
    //移除清除线条监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ClearLinesFromView" object:nil];
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  加载绘制线条监听
 */
- (void)initializeLineNotificationToSelf
{
    //加载绘制线条监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawLinesToView:) name:@"DrawLinesToView" object:nil];

    //加载清除线条监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearLinesFromView:) name:@"ClearLinesFromView" object:nil];
}

/**
 *  加载MindMapView
 */
- (void)initializeMindMapView
{
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mindMapViewRootImageViewClicked:)];
    
    UIImageView *mindMapViewRootImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start"]];
    
    mindMapViewRootImageView.size = CGSizeMake(80, 80);
    mindMapViewRootImageView.userInteractionEnabled = YES;
    mindMapViewRootImageView.contentMode = UIViewContentModeScaleAspectFit;
    mindMapViewRootImageView.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 2.5);
    
    [mindMapViewRootImageView addGestureRecognizer:singleTapGesture];
    
    [self addSubview:mindMapViewRootImageView];
}

#pragma mark -
#pragma mark - UIGestureRecognizer Action Methods

/**
 *  根节点点击事件
 *
 *  @param recognizer 点击
 */
- (void)mindMapViewRootImageViewClicked:(UITapGestureRecognizer *)recognizer
{
    if (!mindMapViewManager)
    {
        CGPoint rootPoint = recognizer.view.center;
        
        UIImage *image = [UIImage imageNamed:@"icon-twitter"];
        
        NSArray *imageArray = @[image, image, image, image, image];
        
        mindMapViewManager = [[MindMapViewManager alloc] initWithRootItemCenterPosition:rootPoint menuItemImageArray:imageArray rootBackgroundView:self andManagerType:MindMapViewManagerTypeForImageNode];
    }
    
    if (mindMapViewManager.closeOrOpenMindMap)
    {
        //MindMapView当前处于打开状态,需要关闭
        [mindMapViewManager closeMindMapView];
    }
    else
    {
        //MindMapView当前处于关闭状态,需要打开
        [mindMapViewManager openMindMapView];
    }
}

#pragma mark -
#pragma mark - Notification Action Methods

/**
 *  添加线条到视图之上
 *
 *  @param notification 通知
 */
- (void)drawLinesToView:(NSNotification *)notification
{
    if (notification.userInfo)
    {
        NSMutableArray *tempPositionArray = [notification.userInfo objectForKey:@"MindMapNodeViewPositionArray"];
        
        if ([nodePositionArray count] == 0)
        {
            [nodePositionArray addObjectsFromArray:tempPositionArray];
        }
        else
        {
            [self replaceObjectInSearchArray:nodePositionArray withArray:tempPositionArray];
        }
        
        [self setNeedsDisplay];
    }
}

/**
 *  从视图上清除线条
 *
 *  @param notification 通知
 */
- (void)clearLinesFromView:(NSNotification *)notification
{
    if (notification.userInfo)
    {
        NSArray *tempPositionArray = [notification.userInfo objectForKey:@"MindMapNodeViewPositionArray"];
        
        CGPoint subRootPoint = [[tempPositionArray firstObject] CGPointValue];
        
        [self replaceArrayInSearchArray:nodePositionArray withLastArray:nodePositionArray andArrayIndex:0 withSubRootPoint:subRootPoint];
        
        [self setNeedsDisplay];
    }
}

#pragma mark -
#pragma mark -  Private Traverse TreeArray Methods

/**
 *  遍历原数组,添加数组成员进入
 *
 *  @param searchArray 遍历的数组
 *  @param givenArray  添加的数组
 */
- (void)replaceObjectInSearchArray:(NSMutableArray *)searchArray withArray:(NSMutableArray *)givenArray
{
    CGPoint subRootNodePosition = [[givenArray firstObject] CGPointValue];
    
    for (NSInteger index = 0; index < [searchArray count]; index ++)
    {
        id tempValue = [searchArray objectAtIndex:index];
        
        if ([tempValue isKindOfClass:[NSMutableArray class]])
        {
            [self replaceObjectInSearchArray:tempValue withArray:givenArray];
        }
        else
        {
            if ([tempValue CGPointValue].x == subRootNodePosition.x && [tempValue CGPointValue].y == subRootNodePosition.y)
            {
                [searchArray replaceObjectAtIndex:index withObject:givenArray];
            }
        }
    }
}

/**
 *  遍历原数组,移除数组成员出去,添加节点数据
 *
 *  @param searchArray  遍历的数组
 *  @param lastArray    遍历的数组中的上一级数组(用户调用不需要给)
 *  @param indexPath    遍历的数组中的上一级数组的序号(用户调用不需要给)
 *  @param subRootPoint 添加的节点数据
 */
- (void)replaceArrayInSearchArray:(NSMutableArray *)searchArray withLastArray:(NSMutableArray *)lastArray andArrayIndex:(NSInteger)indexPath withSubRootPoint:(CGPoint)subRootPoint
{
    //判断存放线条的数组当中是否存在数组类型的数据
    BOOL existSubMenu = NO;
    
    for (NSInteger index = 0; index < [searchArray count]; index ++)
    {
        id tempValue = [searchArray objectAtIndex:index];
        
        if ([tempValue isKindOfClass:[NSMutableArray class]])
        {
            existSubMenu = YES;
            break;
        }
    }
    
    if (existSubMenu)
    {
        //存在数组类型的数据
        for (NSInteger index = 0; index < [searchArray count]; index ++)
        {
            id tempValue = [searchArray objectAtIndex:index];
            
            if ([tempValue isKindOfClass:[NSMutableArray class]])
            {
                [self replaceArrayInSearchArray:tempValue withLastArray:searchArray andArrayIndex:index withSubRootPoint:subRootPoint];
            }
            else
            {
                if ([tempValue CGPointValue].x == subRootPoint.x && [tempValue CGPointValue].y == subRootPoint.y)
                {
                    [lastArray replaceObjectAtIndex:indexPath withObject:[NSValue valueWithCGPoint:subRootPoint]];
                }
            }
        }
    }
    else
    {
        //不存在数组类型数据
        for (NSInteger index = 0; index < [searchArray count]; index ++)
        {
            id tempValue = [searchArray objectAtIndex:index];
            
            if ([tempValue CGPointValue].x == subRootPoint.x && [tempValue CGPointValue].y == subRootPoint.y)
            {
                [lastArray replaceObjectAtIndex:indexPath withObject:[NSValue valueWithCGPoint:subRootPoint]];
                
                [searchArray removeAllObjects];
            }
        }
    }
}

/**
 *  绘制节点之间的连线,通过遍历节点数组
 *
 *  @param rootArray 节点数组
 *  @param context   绘画句柄
 */
- (void)drawerLinesByTraverseNodePositionArrayWithArray:(NSMutableArray *)rootArray andCGContextRef:(CGContextRef)context
{
    //本级数组中的根节点坐标
    CGPoint rootPoint = [[rootArray firstObject] CGPointValue];
    
    for (NSInteger index = 1; index < [rootArray count]; index ++)
    {
        id tempValue = [rootArray objectAtIndex:index];
        
        //定义叶子节点坐标
        CGPoint leafNodePoint = CGPointZero;
        
        //设置画笔颜色
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        //设置画笔宽度
        CGContextSetLineWidth(context, 1.0);
        //设置画笔起点
        CGContextMoveToPoint(context, rootPoint.x, rootPoint.y);
        
        if ([tempValue isKindOfClass:[NSMutableArray class]])
        {
            //数组类型数据,取数组的首节点
            leafNodePoint = [[tempValue firstObject] CGPointValue];
            
            //设置画笔终点
            CGContextAddLineToPoint(context, leafNodePoint.x, leafNodePoint.y);
            //绘制线条
            CGContextStrokePath(context);
            
            [self drawerLinesByTraverseNodePositionArrayWithArray:tempValue andCGContextRef:context];
        }
        else
        {
            //点类型数据,直接绘制线条将根节点和叶子节点连接起来
            leafNodePoint = [tempValue CGPointValue];
            
            //设置画笔终点
            CGContextAddLineToPoint(context, leafNodePoint.x, leafNodePoint.y);
            //绘制线条
            CGContextStrokePath(context);
        }
    }
}

@end
