//
//  UIView+Corner.m
//  DSH
//
//  Created by 张毅成 on 2018/9/28.
//  Copyright © 2018 WZX. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void)setCorner {
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = true;
}

- (void)setShadow {
    self.layer.cornerRadius = 10.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    self.layer.shadowRadius = 3;//阴影半径，默认3
}

@end
