//
//  MindMapViewController.h
//  ASIA
//
//  Created by Kevin on 15/3/27.
//  Copyright (c) 2015年 FreeWave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMScrollView.h"
#import "MindMapBackgroundView.h"

@interface MindMapViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) SMScrollView *mindMapScrollView;

@property (nonatomic, strong) MindMapBackgroundView *mindMapBackgroundView;

@end
