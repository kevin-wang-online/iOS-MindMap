//
//  MindMapView.h
//  MindMap
//
//  Created by Kevin on 15/3/16.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MindMapNodeView.h"
#import "MindMapBackgroundView.h"

//思维导图控制器类型
typedef enum MindMapViewManagerType
{
    MindMapViewManagerTypeForImageNode,
    MindMapViewManagerTypeForInfoNode
} MindMapViewManagerType;

@class MindMapBackgroundView;

@interface MindMapViewManager : NSObject <MindMapNodeViewDelegate>

- (instancetype)initWithRootItemCenterPosition:(CGPoint)center menuItemImageArray:(NSArray *)imageArray rootBackgroundView:(MindMapBackgroundView *)backgroundView andManagerType:(MindMapViewManagerType)type;

//思维导图类型
@property (nonatomic, assign) MindMapViewManagerType managerType;

//思维导图的根视图
@property (nonatomic, strong) MindMapBackgroundView *mindMapBackgrounbView;

//根节点位置坐标
@property (nonatomic, assign) CGPoint rootItemPosition;

//本级节点数量
@property (nonatomic, assign) NSUInteger numberOfMenuItem;

//本级节点位置数组
@property (nonatomic, strong) NSMutableArray *menuItemPositionArray;

//本级节点图片数组
@property (nonatomic, strong) NSMutableArray *menuItemImageArray;

//本级节点视图数组
@property (nonatomic, strong) NSMutableArray *menuItemMapNodeViewArray;

//本级思维导图打开关闭状态
@property (nonatomic, assign) BOOL closeOrOpenMindMap;

//打开MindMaoView
- (void)openMindMapView;

//关闭MindMaoView
- (void)closeMindMapView;

//清楚该对象中的所有相关配置属性信息
- (void)destroyAllSettingInfomation;

@end
