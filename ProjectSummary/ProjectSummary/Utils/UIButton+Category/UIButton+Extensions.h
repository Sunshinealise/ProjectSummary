//
//  UIButton+Extensions.h
//  ButtonEnlarge
//
//  Created by zhanshu on 14-5-28.
//  Copyright (c) 2014年 zhanshu. All rights reserved.
//

//扩大按钮的点击范围

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;
- (void)setBackNormalImageWith:(NSString *)imgName;
- (void)setTitleNormalWith:(NSString *)title;
- (void)setTitleColorNormalWith:(UIColor *)color;
- (void)setNormalImageWith:(NSString*)imgName;
- (void)setSelectedImg:(NSString *)selectedImgName;

@end
