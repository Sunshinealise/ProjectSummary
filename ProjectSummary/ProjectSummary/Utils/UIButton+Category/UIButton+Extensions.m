//
//  UIButton+Extensions.m
//  ButtonEnlarge
//
//  Created by zhanshu on 14-5-28.
//  Copyright (c) 2014年 zhanshu. All rights reserved.
//

#import "UIButton+Extensions.h"
#import <objc/runtime.h>

@implementation UIButton (Extensions)

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets;
        [value getValue:&edgeInsets];
        return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

- (void)setNormalImageWith:(NSString *)imgName {
    [self setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)setBackNormalImageWith:(NSString *)imgName {
    [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}
- (void)setTitleNormalWith:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColorNormalWith:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}
- (void)setSelectedImg:(NSString *)selectedImgName {
    [self setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
}

@end
