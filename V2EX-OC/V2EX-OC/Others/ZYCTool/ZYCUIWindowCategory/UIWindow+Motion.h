//
//  UIWindow+Motion.h
//  DSH
//
//  Created by 张毅成 on 2018/10/11.
//  Copyright © 2018 WZX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define UIEventSubtypeMotionShakeNotification @"UIEventSubtypeMotionShakeNotification"

@interface UIWindow (Motion)
// @override
- (BOOL)canBecomeFirstResponder;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
