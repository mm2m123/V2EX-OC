//
//  ZYCTool.h
//  ttt
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 张毅成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//屏幕宽度比
#define WIDTH_SCALE [UIScreen mainScreen].bounds.size.width / 375
//屏幕高度比
#define HEIGHT_SCALE [UIScreen mainScreen].bounds.size.height / 667

#define kIsHaveBang [ZYCTool isHaveBang]//判断是否是刘海屏系列
//高适配
#define Height_Layout(a) kIsHaveBang?a:a*HEIGHT_SCALE
//宽适配
#define Width_Layout(a) kIsHaveBang?a:a*WIDTH_SCALE
@interface ZYCTool : NSObject
typedef void (^NotAvailable)(void);
typedef void (^Available)(void);
typedef void (^returnCancel)(void);
typedef void (^returnNotarize)(void);
typedef void (^returnNotarizeWithIdx)(NSInteger idx);

@property (strong, nonatomic) UIAlertController *alertController;
@property (copy, nonatomic) returnNotarize returnNotarize;
@property (copy, nonatomic) returnCancel returnCancel;
@property (copy, nonatomic) returnNotarizeWithIdx returnNotarizeWithIdx;

/**
 弹出alert 配两个button

 @param title alert的标题
 @param message alert的详细信息
 @param viewController 要弹出alert的控制器
 @param notarizeButtonTitle 确认按钮的title传nil的话显示@"确认"
 @param cancelButtonTitle 取消按钮的title传nil的话显示@"取消"
 @param notarize 点击确认的回调
 @param cancel 点击取消的回调
 */
+ (void)alertControllerTwoButtonWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)viewController notarizeButtonTitle:(NSString *)notarizeButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle notarizeAction:(returnNotarize)notarize cancelAction:(returnCancel)cancel;

/**
 弹出alert 配一个button

 @param title alert的标题
 @param message alert的详细信息
 @param viewController 要弹出alert的控制器
 @param defaultButtonTitle 默认按钮的title传nil的话显示@"确认"
 @param defaultAction 点击默认按钮的回调
 */
+ (void)alertControllerOneButtonWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)viewController  defaultButtonTitle:(NSString *)defaultButtonTitle defaultAction:(returnNotarize)defaultAction;


/**
 判断相机是否可用 若不可用会弹出一个alertController 点击确认跳转到设置 取消进行NotAvailable block的操作

 @param viewController 要在哪个页面调用相机
 @param Available 相机可用时的block
 @param NotAvailable 相机不可用时的block
 */
+ (void)controller:(UIViewController *)viewController CameraIsAvailable:(Available)Available OrNotAvailable:(NotAvailable)NotAvailable;

/**
 判断相册是否可用 若不可用会弹出一个alertController 点击确认跳转到设置 取消进行NotAvailable block的操作

 @param viewController 要在哪个页面调用相册
 @param Available 相册可用时的block
 @param NotAvailable 相册不可用时的block
 */
+ (void)controller:(UIViewController *)viewController AlbumIsAvailable:(Available)Available OrNotAvailable:(NotAvailable)NotAvailable;


/**
 倒计时

 @param countTime 倒计时的时间(秒)
 @param counting 倒计时中的block
 @param finished 完成的block
 */
+ (void)countDownWithTime:(NSInteger)countTime AndCounting:(void(^)(NSInteger count))counting AndFinished:(void(^)(void))finished;

+ (void)actionSheetWithTitleArray:(NSMutableArray *)titleArray target:(UIViewController *)viewController notarizeAction:(returnNotarizeWithIdx)returnNotarizeWithIdx;

+ (BOOL)isCompany:(id)obj;

/**


 @return 是否是刘海屏系列
 */
+ (BOOL)isHaveBang;

/**
 震动反馈
 */
+ (void)feedBack;
@end
