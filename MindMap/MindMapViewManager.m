//
//  MindMapView.m
//  MindMap
//
//  Created by Kevin on 15/3/16.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import "MindMapViewManager.h"
#import "MindMapNodeView.h"

static const CGFloat kAngleOffset = M_PI_4 / 2.0;
static const CGFloat kCircleRadius = 150;

@interface MindMapViewManager()
{
    CGFloat angle;
    
    CGFloat mindMapCircleRadius;
}

@end

@implementation MindMapViewManager

@synthesize managerType;

@synthesize mindMapBackgrounbView;

@synthesize rootItemPosition;

@synthesize numberOfMenuItem;
@synthesize menuItemImageArray;
@synthesize menuItemPositionArray;
@synthesize menuItemMapNodeViewArray;

@synthesize closeOrOpenMindMap;


#pragma mark -
#pragma mark - Init Methods

- (instancetype)initWithRootItemCenterPosition:(CGPoint)center menuItemImageArray:(NSArray *)imageArray rootBackgroundView:(MindMapBackgroundView *)backgroundView andManagerType:(MindMapViewManagerType)type
{
    if (self = [super init])
    {
        closeOrOpenMindMap = NO;
        
        managerType = type;
        
        mindMapBackgrounbView = backgroundView;
        
        angle = kAngleOffset;
        mindMapCircleRadius = kCircleRadius;
        
        rootItemPosition = center;
        numberOfMenuItem = [imageArray count];
        menuItemImageArray = [[NSMutableArray alloc] initWithArray:imageArray];
        
        //初始化节点坐标
        [self initializeMindMapNodePosition];
        
        //初始MindMapView节点视图
        [self initializeMindMapNodeViews];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  初始化所有子节点坐标
 */
- (void)initializeMindMapNodePosition
{
    menuItemPositionArray = [[NSMutableArray alloc] init];
    
    for (NSInteger index = 0; index < numberOfMenuItem; index ++)
    {
        CGFloat firstAngle = M_PI + (M_PI - angle * 3.0) + index * angle;
        
        CGPoint startPoint = rootItemPosition;
        
        CGFloat x = startPoint.x + cos(firstAngle) * mindMapCircleRadius;
        
        CGFloat y = startPoint.y + sin(firstAngle) * mindMapCircleRadius;
        
        CGPoint position = CGPointMake(x, y);
        
        [menuItemPositionArray addObject:[NSValue valueWithCGPoint:position]];
    }
}

/**
 *  初始MindMapView节点视图
 */
- (void)initializeMindMapNodeViews
{
    menuItemMapNodeViewArray = [[NSMutableArray alloc] init];
    
    for (NSInteger index = 0; index < numberOfMenuItem; index ++)
    {
        UIImage *nodeImage = menuItemImageArray[index];
        
        CGPoint nodePosition = [menuItemPositionArray[index] CGPointValue];
        
        MindMapNodeView *nodeView = nil;
        
        if (managerType == MindMapViewManagerTypeForImageNode)
        {
            //图片类型节点
            nodeView = [[MindMapNodeView alloc] initWithNodeViewCenter:nodePosition andRootNodeViewCenter:rootItemPosition andNodeImage:nodeImage andNodeType:MindMapNodeViewDramaImageType];
        }
        else
        {
            //文本类型节点
            nodeView = [[MindMapNodeView alloc] initWithNodeViewCenter:nodePosition andRootNodeViewCenter:rootItemPosition andNodeString:@"节点当中的数据内容" andNodeType:MindMapNodeViewDramaInfoType];
        }
        
        nodeView.tag = index;
        nodeView.delegate = self;
        nodeView.userInteractionEnabled = YES;
        nodeView.equalNodeViewsArray = menuItemMapNodeViewArray;
        
        [menuItemMapNodeViewArray addObject:nodeView];
    }
}

#pragma mark -
#pragma mark - Public Methods

/**
 *  打开MindMapView
 */
- (void)openMindMapView
{
    closeOrOpenMindMap = YES;
    
    for (NSInteger index = 0; index < numberOfMenuItem; index ++)
    {
        MindMapNodeView *nodeView = [menuItemMapNodeViewArray objectAtIndex:index];
        
        [mindMapBackgrounbView addSubview:nodeView];
    }
    
    NSMutableArray *positionArray = [[NSMutableArray alloc] initWithArray:menuItemPositionArray];
    
    [positionArray insertObject:[NSValue valueWithCGPoint:rootItemPosition] atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawLinesToView" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:positionArray,@"MindMapNodeViewPositionArray", nil]];
}

/**
 *  关闭MindMapView
 */
- (void)closeMindMapView
{
    closeOrOpenMindMap = NO;
    
    for (NSInteger index = 0; index < numberOfMenuItem; index ++)
    {
        MindMapNodeView *nodeView = [menuItemMapNodeViewArray objectAtIndex:index];
    
        if (nodeView.openOrCloseMindMapView)
        {
            //该参数为YES,表示该节点下存在展开的子节点,统统需要关闭
            [nodeView.subMindMapViewManager closeMindMapView];
            
            [nodeView setOpenOrCloseMindMapView:NO];
        }
        
        [nodeView removeFromSuperview];
    }
    
    NSMutableArray *positionArray = [[NSMutableArray alloc] initWithArray:menuItemPositionArray];
    
    [positionArray insertObject:[NSValue valueWithCGPoint:rootItemPosition] atIndex:0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearLinesFromView" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:positionArray,@"MindMapNodeViewPositionArray", nil]];
}

/**
 *  销毁该对象中的所有配置信息
 */
- (void)destroyAllSettingInfomation
{
    menuItemPositionArray = nil;
    menuItemImageArray = nil;
    menuItemMapNodeViewArray = nil;
}

@end
