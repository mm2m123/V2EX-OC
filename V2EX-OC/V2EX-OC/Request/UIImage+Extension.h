//
//  UIImage+Extension.h
//  knowledgeBase
//
//  Created by 王洪亮 on 16/9/20.
//  Copyright © 2016年 wanghongliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (Extension)


- (UIImage *)fixOrientation;

/**
 通过颜色生成图片

 @param color color description
 @param alpha alpha description
 @return return value description
 */
+ (UIImage *)imageWithBgColor:(UIColor *)color alpha:(CGFloat)alpha;


/**
 旋转图片

 @return return value description
 */
- (UIImage *)horTransform;



/**
 圆角图片

 @param radius radius description
 @param size size description
 @return return value description
 */
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;


+ (UIImage *)boxblurImageWithBlur:(CGFloat)blur andImage:(UIImage *)image;

- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
                      tintMode:(CGBlendMode)tintBlendMode
                    saturation:(CGFloat)saturation
                     maskImage:(UIImage *)maskImage;


+ (UIImage *)originImageWithName:(NSString *)name ;
- (UIImage *)circleImage;
@end
