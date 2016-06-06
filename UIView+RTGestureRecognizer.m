//
//  UIView+RTGestureRecognizer.m
//  UIGestureRecognizer
//
//  Created by MacBook on 16/6/3.
//  Copyright © 2016年 MacBook. All rights reserved.
//

#import "UIView+RTGestureRecognizer.h"
#import "Constants.h"
#import <objc/runtime.h>

@interface UIView () <UIGestureRecognizerDelegate>
//纪录每次点击view时，view的初始frame
@property(nonatomic,strong)NSValue *rectValue;
//纪录view自身的旋转角度
@property(nonatomic,strong)NSNumber *rotateAngle;
@end

static void *rectValueKey = (void *)@"rectValueKey";
static void *rotateAngleKey = (void *)@"rotateAngleKey";

@implementation UIView (RTGestureRecognizer)
#pragma mark-- associative添加属性
- (NSValue *)rectValue
{
    return objc_getAssociatedObject(self, rectValueKey);
}
- (void)setRectValue:(NSValue *)value
{
    objc_setAssociatedObject(self, rectValueKey, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSNumber *)rotateAngle
{
    return objc_getAssociatedObject(self, rotateAngleKey);
}
- (void)setRotateAngle:(NSNumber *)value
{
    objc_setAssociatedObject(self, rotateAngleKey, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark-- 手势配置
- (void)gestureConfig
{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleRotate:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePinch:)];
    UITapGestureRecognizer *tapch = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(handleTap:)];
    tapch.numberOfTouchesRequired = 1;
    tapch.numberOfTapsRequired = 1;
    tapch.delegate = self;
    pan.delegate = self;
    rotate.delegate = self;
    pinch.delegate = self;
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:rotate];
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:tapch];
}
#pragma mark-- 事件
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self];
    if ([self.rotateAngle floatValue] == 0) {
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    }
//对translation进行角度补偿，如果旋转是正角度则补偿负角度，反之，则补偿正角度
    if ([self.rotateAngle floatValue] < 0) {
        CGFloat angle = -[self.rotateAngle floatValue];
        CGFloat dx = translation.x*cosf(angle) + translation.y*sinf(angle);
        CGFloat dy = -translation.x*sinf(angle) + translation.y*cosf(angle);
        recognizer.view.center = CGPointMake(recognizer.view.center.x + dx,recognizer.view.center.y + dy);
    }
    if ([self.rotateAngle floatValue] > 0) {
        CGFloat angle = [self.rotateAngle floatValue];
        CGFloat dx = translation.x*cosf(angle) - translation.y*sinf(angle);
        CGFloat dy = translation.x*sinf(angle) + translation.y*cosf(angle);
        recognizer.view.center = CGPointMake(recognizer.view.center.x + dx,recognizer.view.center.y + dy);
    }
    [recognizer setTranslation:CGPointZero inView:self];
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.frame.size.width == [self beginRect].size.width && self.frame.size.height == [self beginRect].size.height) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = [self beginRect];
            }];
        }
        if (self.frame.size.width == screenSize.size.width && self.frame.size.height == screenSize.size.height) {
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = screenSize;
            }];
        }
    }
}
- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    CGFloat angle = [self.rotateAngle floatValue] + recognizer.rotation;
    self.rotateAngle = [NSNumber numberWithFloat:angle];
    recognizer.rotation = 0;
    
    NSLog(@"%f",[self.rotateAngle floatValue]);
//纪录角度，每次结束回零
    if (recognizer.state==UIGestureRecognizerStateEnded) {
        self.rotateAngle = [NSNumber numberWithInteger:0];
    }
}
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
//结束后恢复
    if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        if (self.frame.size.width >= [UIScreen mainScreen].bounds.size.width) {
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformIdentity;
                self.frame = screenSize;
            }];
        }
        else if(self.frame.size.width < [UIScreen mainScreen].bounds.size.width){
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformIdentity;
                self.frame = [self beginRect];
            }];
        }
    }
}
- (void)handleTap:(UIPinchGestureRecognizer *)recognizer
{
//确保在移动或者旋转时不会因为误操作而改变视图结构
    if ([[self rotateAngle] floatValue] >= -0.05 && [[self rotateAngle] floatValue] <= 0.05) {
        if (self.frame.size.width < [UIScreen mainScreen].bounds.size.width)
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = screenSize;
            } completion:^(BOOL finished) {
                if (finished) {
                }
            }];
        else
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = [self beginRect];
            } completion:^(BOOL finished) {
                if (finished) {
                }
            }];
    }
}
#pragma mark-- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark-- myFunction
- (CGRect)beginRect
{
    CGRect beginR = [self.rectValue CGRectValue];
    return beginR;
}
#pragma mark-- touchs
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.frame.size.width != screenSize.size.width && self.frame.size.height != screenSize.size.height) {
        [self setRectValue:[NSValue valueWithCGRect:self.frame]];
    }
//总是最上层显示
    [self.superview bringSubviewToFront:self];
}
@end
