# MindMap

树状结构的展开的思维导图

可实现结构知识点的树状分层展示，树状层次可根据特定的数据格式进行分层加载以及关闭。

使用方式：

项目中导入MindMapViewController试图控制器类以及思维导图模块

导图初始化方法

/**
 *  加载MindMap背景视图
 */
- (void)initializeMindMapView
{
    //加载背景视图
    mindMapBackgroundView = [[MindMapBackgroundView alloc] initWithFrame:CGRectMake( 0, 0, 3 * ScreenWidth, 3 * ScreenHeight)];

    mindMapScrollView = [[SMScrollView alloc] initWithFrame:self.view.bounds];
   
   
    //背景色
    
    mindMapScrollView.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];、
    
    //最大放大比例
    
    mindMapScrollView.maximumZoomScale = 4;
    
    //设置委托
    
    mindMapScrollView.delegate = self;
    
    //尺寸变换模式
    
    mindMapScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //内容尺寸
    
    mindMapScrollView.contentSize = mindMapBackgroundView.size;
    
    mindMapScrollView.alwaysBounceVertical = YES;
    
    mindMapScrollView.alwaysBounceHorizontal = YES;
    
    mindMapScrollView.stickToBounds = YES;
    
    [mindMapScrollView addViewForZooming:mindMapBackgroundView];
    
    [mindMapScrollView scaleToFit];
    
    
    //添加视图
    
    [self.view addSubview:mindMapScrollView];
    
}
