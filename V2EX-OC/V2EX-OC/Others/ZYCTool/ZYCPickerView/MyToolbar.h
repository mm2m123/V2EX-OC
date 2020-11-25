//
//  MyToolbar.h
//  SYSports
//
//  Created by MD101 on 15/12/4.
//  Copyright © 2015年 liuwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SelectBtnType) {
    SelectBtnTypeCancel,
    SelectBtnTypeDone,
    
};
@interface MyToolbar : UIToolbar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (nonatomic,copy) void(^clickBtn)(SelectBtnType type);
@end
