//
//  Frements.h
//  SizeClass
//
//  Created by Kevin on 15/3/3.
//  Copyright (c) 2015年 kevin. All rights reserved.
//

#import "AppDelegate.h"
#import "UIViewExt.h"

//===============================获取导航/状态栏高高度================================//

#define StatusBarHeight         [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavigationBarHeight     self.navigationController.navigationBar.frame.size.height
#define SearchBarHeight           44

//===============================获取设备宽高================================//

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//=============================判断当前设备型号==============================//

#define iPhone4or4SoriPod4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5or5SoriPod5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6o6S  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plusor6SPlus  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//=============================判断当前系统版本号==============================//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS8orLater  [UIDevice currentDevice].systemVersion.floatValue >= 8.0 ? YES:NO

//=================================读取本地图片=================================//
#define LoadImageFromLocal(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

#define GetImageWithName(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//=================================颜色获取以及转换=================================//

#define UIColorFromRGB16Value(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]


//=================================角度&弧度相互转换=================================//
//
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//=============================获取当前设备设置的默认语言=============================//
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//=================================Debug调试下打印信息=================================//

#ifdef  DEBUG
#define LOG(...) NSLog(__VA_ARGS__);
#define LOG_METHOD NSLog(@"%s", __func__);
#else
#define LOG(...);
#define LOG_METHOD;
#endif

//==============================NSLog的更好的版本==============================//
#define NSLog(format, ...) do {                                                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

//=================================单例化一个类=================================//
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}

//==========================适配6和6Plus的一种方法===========================//

////判断当前设备，决定设备尺寸系数
//AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//
//if (ScreenHeight > 480)
//{
//    appDelegate.autoSizeScaleX = ScreenWidth/320;
//    appDelegate.autoSizeScaleY = ScreenHeight/568;
//}
//else
//{
//    appDelegate.autoSizeScaleX = 1.0;
//    appDelegate.autoSizeScaleY = 1.0;
//}
