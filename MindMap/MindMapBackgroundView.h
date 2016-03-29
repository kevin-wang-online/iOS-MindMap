//
//  MindMapBackgroundView.h
//  MindMap
//
//  Created by Kevin on 15/3/20.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MindMapViewManager.h"

@class MindMapViewManager;

@interface MindMapBackgroundView : UIView

@property (strong, nonatomic) MindMapViewManager *mindMapViewManager;

//清除该视图的监听
- (void)removeAllDrawNotifications;

@end
