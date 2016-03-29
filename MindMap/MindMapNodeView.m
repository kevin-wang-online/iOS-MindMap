//
//  MindMapNodeImageView.m
//  MindMap
//
//  Created by Kevin on 15/3/16.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import "MindMapNodeView.h"
#import "MindMapViewManager.h"

#define kMindMapNodeBackgroundViewWidthAndHeight         50
#define KMindMapNodeDramaImageViewWidth                  40
#define KMindMapNodeDramaImageViewHeight                 30

@implementation MindMapNodeView

@synthesize nodeType;
@synthesize rootPosition;
@synthesize nodeImageView;
@synthesize backgroundImageView;
@synthesize subMindMapViewManager;
@synthesize singleTapGesture;
@synthesize equalNodeViewsArray;
@synthesize openOrCloseMindMapView;

#pragma mark -
#pragma mark - Init Methods

/**
 *  初始化方法   图片节点
 *
 *  @param nodePostion    节点坐标
 *  @param rootNodeCenter 根节点坐标
 *  @param nodeImage      节点图片
 *
 *  @return 节点对象
 */
- (id)initWithNodeViewCenter:(CGPoint)nodePostion andRootNodeViewCenter:(CGPoint)rootNodeCenter andNodeImage:(UIImage *)nodeImage andNodeType:(MindMapNodeViewType)type
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kMindMapNodeBackgroundViewWidthAndHeight, kMindMapNodeBackgroundViewWidthAndHeight)])
    {
        openOrCloseMindMapView = NO;
        
        nodeType = type;
        rootPosition = rootNodeCenter;
        
        self.center = nodePostion;
        self.userInteractionEnabled = YES;
        
        //展开下一级触发动作
        singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMindMapNodeImageView:)];
        
        //图片节点背景视图
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMindMapNodeBackgroundViewWidthAndHeight, kMindMapNodeBackgroundViewWidthAndHeight)];
        
        [backgroundImageView setUserInteractionEnabled:YES];
        [backgroundImageView addGestureRecognizer:singleTapGesture];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [backgroundImageView setImage:[UIImage imageNamed:@"backgroundNode"]];
        
        //图片节点图片视图
        nodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KMindMapNodeDramaImageViewWidth, KMindMapNodeDramaImageViewHeight)];
        
        [nodeImageView setImage:nodeImage];
        [nodeImageView setUserInteractionEnabled:YES];
        [nodeImageView setCenter:backgroundImageView.center];
        
        //图片视图上的播放按钮
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [playButton setFrame:CGRectMake(12.5, 7.5, 15, 15)];
        [playButton setContentMode:UIViewContentModeScaleAspectFit];
        [playButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(dramaPlayButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [nodeImageView addSubview:playButton];
        [backgroundImageView addSubview:nodeImageView];
        [self addSubview:backgroundImageView];
    }
    
    return self;
}

/**
 *  初始化方法   文本节点
 *
 *  @param nodePostion    节点坐标
 *  @param rootNodeCenter 根节点坐标
 *  @param nodeString     节点字符内容
 *  @param type           节点类型
 *
 *  @return 节点对象
 */
- (id)initWithNodeViewCenter:(CGPoint)nodePostion andRootNodeViewCenter:(CGPoint)rootNodeCenter andNodeString:(NSString *)nodeString andNodeType:(MindMapNodeViewType)type
{
    if (self = [super initWithFrame:CGRectMake(0, 0, kMindMapNodeBackgroundViewWidthAndHeight, kMindMapNodeBackgroundViewWidthAndHeight)])
    {
        openOrCloseMindMapView = NO;
        
        nodeType = type;
        rootPosition = rootNodeCenter;
        
        self.center = nodePostion;
        self.userInteractionEnabled = YES;
        
        //展开下一级触发动作
        singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMindMapNodeImageView:)];
        
        //文字节点背景视图
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMindMapNodeBackgroundViewWidthAndHeight, kMindMapNodeBackgroundViewWidthAndHeight)];
        
        [backgroundImageView setUserInteractionEnabled:YES];
        [backgroundImageView addGestureRecognizer:singleTapGesture];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [backgroundImageView setImage:[UIImage imageNamed:@"backgroundNode"]];
        
        //文字节点文字视图
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KMindMapNodeDramaImageViewWidth, KMindMapNodeDramaImageViewHeight)];
        
        [contentLabel setText:@"123456123456123456123456123456123456"];
        [contentLabel setNumberOfLines:0];
        [contentLabel setAdjustsFontSizeToFitWidth:YES];
        [contentLabel setTextColor:[UIColor whiteColor]];
        [contentLabel setCenter:backgroundImageView.center];
        [contentLabel setTextAlignment:NSTextAlignmentCenter];
        
        [backgroundImageView addSubview:contentLabel];
        
        [self addSubview:backgroundImageView];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Action Methods

/**
 *  用户点击节点视图出发事件
 *
 *  @param recognizer 单击动作
 */
- (void)didClickMindMapNodeImageView:(UITapGestureRecognizer *)recognizer
{
    if (!subMindMapViewManager)
    {
        UIImage *image = [UIImage imageNamed:@"icon-facebook"];
        
        NSArray *imageArray = @[image, image, image, image];
        
        subMindMapViewManager = [[MindMapViewManager alloc] initWithRootItemCenterPosition:self.center menuItemImageArray:imageArray rootBackgroundView:(MindMapBackgroundView *)self.superview andManagerType:MindMapViewManagerTypeForInfoNode];
    }
    
    if (openOrCloseMindMapView)
    {
        //此时MindView为打开状态,用户点击需要关闭
        [subMindMapViewManager closeMindMapView];
        [subMindMapViewManager destroyAllSettingInfomation];
        
        subMindMapViewManager = nil;
        
        openOrCloseMindMapView = NO;
    }
    else
    {
        //此时MindView为关闭状态,用户点击需要打开
        
        //遍历同级的所有节点，将除自身以外的其他的节点的子节点统统关闭
        for (MindMapNodeView *nodeView in equalNodeViewsArray)
        {
            if (nodeView == self)
            {
                //寻找到自己，先不做任何处理
            }
            else
            {
                // 需找到其他节点
                if (nodeView.openOrCloseMindMapView)
                {
                    //其他节点处于打开状态,则需要关闭其他节点
                    [nodeView closeCuurentSubMindMapView];
                }
            }
        }
        
        [subMindMapViewManager openMindMapView];
        
        openOrCloseMindMapView = YES;
    }
}

/**
 *  话剧播放按钮点击
 *
 *  @param sender 触发器
 */
- (void)dramaPlayButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(mindMapNodeView:didClickPlayButtonAtIndex:)])
    {
        [self.delegate mindMapNodeView:self didClickPlayButtonAtIndex:self.tag];
    }
}

#pragma mark -
#pragma mark - Public Methods

/**
 *  对外公开方法，关闭当前节点下的所有节点
 */
- (void)closeCuurentSubMindMapView
{
    if (subMindMapViewManager)
    {
        //关闭所有子节点
        [subMindMapViewManager closeMindMapView];
        //销毁子节点下的所有信息
        [subMindMapViewManager destroyAllSettingInfomation];

        subMindMapViewManager = nil;
        
        openOrCloseMindMapView = NO;
    }
}

@end
