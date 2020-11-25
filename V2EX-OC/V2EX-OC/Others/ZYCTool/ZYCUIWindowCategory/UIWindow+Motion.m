//
//  UIWindow+Motion.m
//  DSH
//
//  Created by 张毅成 on 2018/10/11.
//  Copyright © 2018 WZX. All rights reserved.
//

#import "UIWindow+Motion.h"

static UITextField *_textField;

@implementation UIWindow (Motion)

- (BOOL)canBecomeFirstResponder {//默认是NO，所以得重写此方法，设成YES
    return YES;
}


- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {

}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
#if DEBUG
    __block NSString *mainURL = @"";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入访问地址" message:@"此页面仅在测试时显示" preferredStyle:UIAlertControllerStyleAlert];
    // 2.1 添加文本框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        _textField = textField;
        mainURL = USERDEFAULTSGET(@"MainURL");
        if (mainURL.length == 0) {
            mainURL = @"http://47.52.131.83:8888/";
        }
        textField.text = mainURL;
        [textField addTarget:self action:@selector(change:) forControlEvents:(UIControlEventEditingChanged)];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:0 handler:^(UIAlertAction *acton){}];
    UIAlertAction *notarizeAction = [UIAlertAction actionWithTitle:@"确认" style:0 handler:^(UIAlertAction *action){
        if (_textField.text.length > 0) {
            USERDEFAULTSSET(_textField.text, @"MainURL");
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:notarizeAction];
//    [self.rootViewController presentViewController:alertController animated:true completion:^{}];
#endif
}

- (void)change:(UITextField *)textField {
    NSLog(@"");
    _textField = textField;
}

@end
