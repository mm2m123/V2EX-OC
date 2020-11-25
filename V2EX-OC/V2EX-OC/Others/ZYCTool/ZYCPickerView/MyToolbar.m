//
//  MyToolbar.m
//  SYSports
//
//  Created by MD101 on 15/12/4.
//  Copyright © 2015年 liuwei. All rights reserved.
//

#import "MyToolbar.h"

@implementation MyToolbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickBtnItem:(UIBarButtonItem *)sender {
    if (self.clickBtn) {
        self.clickBtn(sender.tag);
    }
    
    
}

@end
