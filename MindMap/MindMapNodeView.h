//
//  MindMapNodeImageView.h
//  MindMap
//
//  Created by Kevin on 15/3/16.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MindMapViewManager;

typedef enum MindMapNodeViewType
{
    MindMapNodeViewDramaInfoType,
    MindMapNodeViewDramaImageType
} MindMapNodeViewType;

@class MindMapNodeView;

@protocol MindMapNodeViewDelegate <NSObject>

- (void)mindMapNodeView:(MindMapNodeView *)nodeView didClickPlayButtonAtIndex:(NSUInteger)index;

@end

@interface MindMapNodeView : UIView

//=================================初始化方法============================================//

- (id)initWithNodeViewCenter:(CGPoint)nodePostion andRootNodeViewCenter:(CGPoint)rootNodeCenter andNodeImage:(UIImage *)nodeImage andNodeType:(MindMapNodeViewType)type;

- (id)initWithNodeViewCenter:(CGPoint)nodePostion andRootNodeViewCenter:(CGPoint)rootNodeCenter andNodeString:(NSString *)nodeString andNodeType:(MindMapNodeViewType)type;

//=================================对外公开操作方法============================================//

//关闭当前节点下的所有子节点
- (void)closeCuurentSubMindMapView;

//====================================本级节点属性=========================================//

//节点类型
@property (nonatomic, assign) MindMapNodeViewType nodeType;

//节点委托
@property (nonatomic, assign) id <MindMapNodeViewDelegate> delegate;

//节点背景视图
@property (nonatomic, strong) UIImageView *backgroundImageView;

//根节点的坐标位置
@property (nonatomic, assign) CGPoint rootPosition;

//节点图片视图
@property (nonatomic, strong) UIImageView *nodeImageView;

//记录节点的状态，是否打开
@property (nonatomic, assign) BOOL openOrCloseMindMapView;

//用户单击动作接收器
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGesture;

//保存一个同级节点的数组,用来判断该级所有节点的状态
@property (nonatomic, strong) NSArray *equalNodeViewsArray;

//====================================下级节点=========================================//

//节点下的MindMapView
@property (nonatomic, strong) MindMapViewManager *subMindMapViewManager;


@end
