//
//  MainMapViewController.m
//  ASIA
//
//  Created by Kevin on 15/3/27.
//  Copyright (c) 2015年 FreeWave. All rights reserved.
//

#import "MindMapViewController.h"

@interface MindMapViewController ()

@end

@implementation MindMapViewController

@synthesize mindMapScrollView;
@synthesize mindMapBackgroundView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"思维导图";
    
    //初始化导航菜单
    [self initializeNavagationBarItems];
    
    //加载MindMapView
    [self initializeMindMapView];
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  初始化导航栏菜单
 */
- (void)initializeNavagationBarItems
{
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackNavigationBarButton:)];
    
    backBarButtonItem.tintColor = UIColorWithRGB(107.0, 107.0, 103.0);
    
    UIBarButtonItem *changeLanguageBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"changeLanguage"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickChangeLanguageNavigationBarButton:)];
    
    changeLanguageBarButtonItem.tintColor = UIColorWithRGB(107.0, 107.0, 103.0);
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    self.navigationItem.rightBarButtonItem = changeLanguageBarButtonItem;
}

/**
 *  加载MindMap背景视图
 */
- (void)initializeMindMapView
{
    //加载背景视图
    mindMapBackgroundView = [[MindMapBackgroundView alloc] initWithFrame:CGRectMake( 0, 0, 3 * ScreenWidth, 3 * ScreenHeight)];
    
    mindMapScrollView = [[SMScrollView alloc] initWithFrame:self.view.bounds];
    
    mindMapScrollView.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];
    mindMapScrollView.maximumZoomScale = 4;
    mindMapScrollView.delegate = self;
    mindMapScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mindMapScrollView.contentSize = mindMapBackgroundView.size;
    mindMapScrollView.alwaysBounceVertical = YES;
    mindMapScrollView.alwaysBounceHorizontal = YES;
    mindMapScrollView.stickToBounds = YES;
    [mindMapScrollView addViewForZooming:mindMapBackgroundView];
    [mindMapScrollView scaleToFit];
    
    [self.view addSubview:mindMapScrollView];
}

#pragma mark -
#pragma mark - Action Methods

/**
 *  点击后退导航菜单按钮
 *
 *  @param sender 触发
 */
- (void)didClickBackNavigationBarButton:(id)sender
{
    //清除监听
    [mindMapBackgroundView removeAllDrawNotifications];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - SMScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return mindMapScrollView.viewForZooming;
}


@end
