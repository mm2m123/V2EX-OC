//
//  PickerView.m
//  TCXF
//
//  Created by 张毅成 on 2017/7/6.
//  Copyright © 2017年 张毅成. All rights reserved.
//

#import "PickerView.h"

@implementation PickerView

- (instancetype)init {
    if (self = [super init]) {
        [self makeUI];
        [self makeToolBar];
    }
    return self;
}

- (void)makeUI {
    _selectIndex = 0;
    self.delegate = self;
    self.dataSource = self;
    self.frame = CGRectMake(0,mScreenHeight * 1.1, mScreenWidth, mScreenHeight / 2);
    self.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
}

- (void)makeToolBar {
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, mScreenHeight * 1.1, mScreenWidth, 40)];
    toolBar.backgroundColor = [UIColor colorWithHexString:@"666666"];
    NSMutableArray *barItems = [NSMutableArray array];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"\t取消" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewDisappear)];
    [cancelBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: kMainColor,  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定\t" style:UIBarButtonItemStylePlain target:self action:@selector(pickerViewDone)];
    [doneBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: kMainColor,  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [barItems addObject:doneBtn];
    toolBar.items = barItems;
    self.toolBar = toolBar;

}

- (void)showView {
    WeakSelf(self)
    [self pickerView:self didSelectRow:self.selectIndex inComponent:0];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.toolBar];
    [UIView animateWithDuration:0.4 animations:^{
        StrongSelf(weakself)
        strongself.hidden = false;
        strongself.toolBar.hidden = false;
        strongself.frame = CGRectMake(0,mScreenHeight / 2, mScreenWidth, mScreenHeight / 2);
        strongself.toolBar.frame = CGRectMake(strongself.frame.origin.x, strongself.frame.origin.y, strongself.frame.size.width, 40);
    } completion:^(BOOL finished) {}];
}

- (void)showinView:(UIView *)view {
    WeakSelf(self)
    [view addSubview:self];
    [view addSubview:self.toolBar];
    [UIView animateWithDuration:0.4 animations:^{
        StrongSelf(weakself)
        strongself.hidden = false;
        strongself.toolBar.hidden = false;
        strongself.frame = CGRectMake(0,view.frame.size.height - mScreenHeight*0.5, mScreenWidth, mScreenHeight*0.5);
        strongself.toolBar.frame = CGRectMake(strongself.frame.origin.x, strongself.frame.origin.y, strongself.frame.size.width, 40);
    } completion:^(BOOL finished) {}];
}

- (void)pickerViewDone {
    WeakSelf(self)
    [UIView animateWithDuration:0.3 animations:^{
        StrongSelf(weakself)
        strongself.frame = CGRectMake(0, 1000, strongself.frame.size.width, 40);
        strongself.toolBar.frame = CGRectMake(0, 1000, strongself.frame.size.width, strongself.toolBar.frame.size.height);
    } completion:^(BOOL finished) {
        StrongSelf(weakself)
        if (self.block) {
            self.block(self.title,_selectIndex);
        }
        strongself.hidden = YES;
        strongself.toolBar.hidden = YES;
        [strongself removeFromSuperview];
        [strongself.toolBar removeFromSuperview];
       
    }];
}

- (void)pickerViewDisappear {
    WeakSelf(self)
    [UIView animateWithDuration:0.3 animations:^{
        StrongSelf(weakself)
        strongself.frame = CGRectMake(0, 1000, strongself.frame.size.width, 40);
        strongself.toolBar.frame = CGRectMake(0, 1000, strongself.frame.size.width, strongself.toolBar.frame.size.height);
    } completion:^(BOOL finished) {
        StrongSelf(weakself)
        strongself.hidden = YES;
        strongself.toolBar.hidden = YES;
        [strongself removeFromSuperview];
        [strongself.toolBar removeFromSuperview];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @[@"男", @"女"][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.title = @[@"男", @"女"][row];
    self.selectIndex = row;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector];
}

@end
