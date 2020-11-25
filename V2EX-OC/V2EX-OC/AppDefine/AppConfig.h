//
//  AppConfig.h
//  V2EX-OC
//
//  Created by 张毅成 on 2020/11/24.
//

#ifndef AppConfig_h
#define AppConfig_h

/**
 ZDTostView
 */
//#define SHOWMESSAGE(a) [ZDTostView showLoadingMessage:a inView:[UIApplication sharedApplication].keyWindow];
//#define SHOWERROR(a) [ZDTostView showErrorMessage:a inView:[UIApplication sharedApplication].keyWindow];
//#define SHOWSUCCESS(a) [ZDTostView showSucceedMessage:a inView:[UIApplication sharedApplication].keyWindow];
//#define SHOWLOADING   [ZDTostView showLoadingMessage:@"加载中..." inView:[UIApplication sharedApplication].keyWindow];
//#define REMOVESHOW [ZDTostView removeLoadingTost];

#define HTTP_BaseURL @"http://www.qmdsw.com/mall/"

/* 其他 */
/// 其他
#define USERDEFAULTSSET(a,b) [[NSUserDefaults standardUserDefaults] setObject:a forKey:b];[[NSUserDefaults standardUserDefaults] synchronize];
#define USERDEFAULTSSETBOOL(a,b) [[NSUserDefaults standardUserDefaults] setBool:a forKey:b];[[NSUserDefaults standardUserDefaults] synchronize];
#define USERDEFAULTSGET(a) [[NSUserDefaults standardUserDefaults] objectForKey:a]
#define IMG(name) [UIImage imageNamed:name]
#define WeakSelf(type)  __weak __typeof(type) weak##type = type;//弱引用
#define StrongSelf(type)  __strong __typeof(self) strongself = type;//强引用
#define kIsHaveBang [ZYCTool isHaveBang]//判断是否是刘海屏系列

//高适配
#define Height_Layout(a) kIsHaveBang?a:a*HEIGHT_SCALE
//宽适配
#define Width_Layout(a) kIsHaveBang?a:a*WIDTH_SCALE

/** 调试模式下输入NSLog，发布后不再输入  (打印信息包括 文件名 + 打印行数 + 打印方法 + 打印内容) */

#if DEBUG
#define NSLog(s , ... )  NSLog(@"[%@ in line:%d %s] \n %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,__FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(FORMAT, ...)
#define debugMethod()
#endif

/**------------------ 方法简写 ------------------ */
#define mScreenWidth        ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define mScreenHeight       ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define mScreenSize         ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)

#else

#define mScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight       ([UIScreen mainScreen].bounds.size.height)
#define mScreenSize         [UIScreen mainScreen].bounds.size
#define mScreenBounds       [UIScreen mainScreen].bounds

#define mStatusBarHeight    [[UIApplication sharedApplication] statusBarFrame].size.height
#define mNavBarHeight       44.0
#define mTabBarHeight       ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83 : 49)
#define mTopHeight          (kIsHaveBang?88:64)
#endif

#define Xrang [ UIScreen mainScreen ].bounds.size.width/375 //屏幕宽比例
#define Yrang [ UIScreen mainScreen ].bounds.size.height/667//屏幕高比例

#define kFeedBack [ZYCTool feedBack];

/** ------------------ 颜色相关 ------------------ */
#define kMainColor [UIColor colorWithRed:0/255.0 green:123/255.0 blue:221/255.0 alpha:1]
#define kBackgroundColor [UIColor hexStringToColor:@"eeeeee"]

//#endif /* AppConfig_h */
