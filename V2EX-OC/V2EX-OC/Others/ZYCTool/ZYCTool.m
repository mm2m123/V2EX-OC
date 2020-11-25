//
//  ZYCTool.m
//  ttt
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 张毅成. All rights reserved.
//

#import "ZYCTool.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>

@implementation ZYCTool

+ (void)alertControllerOneButtonWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)viewController  defaultButtonTitle:(NSString *)defaultButtonTitle defaultAction:(returnNotarize)defaultAction {
    if (defaultButtonTitle.length == 0) {
        defaultButtonTitle = @"确认";
    }
    if (title.length == 0) {
        title = @"";
    }
    if (message.length == 0) {
        message = @"";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultA = [UIAlertAction actionWithTitle:defaultButtonTitle style:0 handler:^(UIAlertAction *actoin){
        if (defaultAction) {
            defaultAction();
        }
        [alertController dismissViewControllerAnimated:true completion:^{}];
    }];
    [alertController addAction:defaultA];
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertControllerTwoButtonWithTitle:(NSString *)title message:(NSString *)message target:(UIViewController *)viewController notarizeButtonTitle:(NSString *)notarizeButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle notarizeAction:(returnNotarize)notarize cancelAction:(returnCancel)cancel {
    if (cancelButtonTitle.length == 0) {
        cancelButtonTitle = @"取消";
    }
    if (notarizeButtonTitle.length == 0) {
        notarizeButtonTitle = @"确认";
    }
    if (title.length == 0) {
        title = @"";
    }
    if (message.length == 0) {
        message = @"";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *acton){
        if (cancel) {
            cancel();
        }
        [alertController dismissViewControllerAnimated:true completion:^{}];
    }];
    UIAlertAction *notarizeAction = [UIAlertAction actionWithTitle:notarizeButtonTitle style:0 handler:^(UIAlertAction *action){
        if (notarize) {
            notarize();
        }
        [alertController dismissViewControllerAnimated:true completion:^{}];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:notarizeAction];
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    [viewController presentViewController: alertController animated:YES completion:nil];
}

+ (void)controller:(UIViewController *)viewController CameraIsAvailable:(Available)Available OrNotAvailable:(NotAvailable)NotAvailable {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        if (Available) {
            Available();
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined) {
        if (Available) {
            Available();
        }
    }else{
        [ZYCTool alertControllerTwoButtonWithTitle:@"没有权限" message:@"点击确定前往设置打开相机权限" target:viewController notarizeButtonTitle:nil cancelButtonTitle:nil notarizeAction:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
            }
        } cancelAction:^{
            if (NotAvailable) {
                NotAvailable();
            }
        }];
    }
}

+ (void)controller:(UIViewController *)viewController AlbumIsAvailable:(Available)Available OrNotAvailable:(NotAvailable)NotAvailable {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        [ZYCTool alertControllerTwoButtonWithTitle:@"没有权限" message:@"点击确定前往设置打开照片权限" target:viewController notarizeButtonTitle:nil cancelButtonTitle:nil notarizeAction:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
            }
        } cancelAction:^{
            if (NotAvailable) {
                NotAvailable();
            }
        }];
        return;
    } else {
        if (Available) {
            Available();
        }
    }
}

+ (void)countDownWithTime:(NSInteger)countTime AndCounting:(void(^)(NSInteger count))counting AndFinished:(void(^)(void))finished {
    __block NSInteger time = countTime; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished();
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (counting) {
                    counting(time);
                }
            });
            time --;
        }
    });
    dispatch_resume(timer);
}

+ (void)actionSheetWithTitleArray:(NSMutableArray *)titleArray target:(UIViewController *)viewController notarizeAction:(returnNotarizeWithIdx)returnNotarizeWithIdx {
    UIAlertController *alertController = [UIAlertController new];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:obj style:0 handler:^(UIAlertAction *action){
            returnNotarizeWithIdx(idx);
        }];
        [alertController addAction:alertAction];
    }];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:1 handler:^(UIAlertAction *action){
        [alertController dismissViewControllerAnimated:true completion:^{}];
    }];
    [alertController addAction:alertAction];
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    [viewController presentViewController: alertController animated:YES completion:nil];
}

+ (BOOL)isCompany:(id)obj {
    NSInteger type = 0;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *string = obj;
        type = string.integerValue;
    }else if ([obj isKindOfClass:[NSNumber class]]) {
        NSNumber *number = obj;
        type = number.integerValue;
    }
    if (type == 1018 || type == 1064 || type == 1065) {
        return true;
    }else
        return false;
}

+ (BOOL)isHaveBang {
    BOOL isHaveBang = false;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return isHaveBang;
    }
    if (@available(iOS 11.0, *)) {
        /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            isHaveBang = YES;
        }
    }
    return isHaveBang;
}

+ (void)feedBack {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
}
@end
