//
//  ZYCTextField.m
//  iDecoration
//
//  Created by 张毅成 on 2018/8/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "ZYCTextField.h"

@implementation ZYCTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //禁止粘贴
    if(action == @selector(paste:)) {
        return false;
    }
    // 禁止选择
    if(action == @selector(select:)) {
        return false;
    }
    // 禁止全选
    if(action == @selector(selectAll:)) {
        return false;
    }
    return[super canPerformAction:action withSender:sender];
}
@end
