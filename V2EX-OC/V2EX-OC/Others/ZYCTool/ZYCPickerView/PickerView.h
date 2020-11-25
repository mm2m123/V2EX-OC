//
//  PickerView.h
//  TCXF
//
//  Created by 张毅成 on 2017/7/6.
//  Copyright © 2017年 张毅成. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickerViewBlock)(NSString *string,NSInteger selectIndex);

@interface PickerView : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, assign) NSInteger selectIndex;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (copy, nonatomic) PickerViewBlock block;
@property (strong, nonatomic) NSString *title;
@property (nonatomic, strong) NSArray *supotdataSource;

- (void)showView;
- (void)showinView:(UIView *)view;
- (void)pickerViewDisappear;
@end
