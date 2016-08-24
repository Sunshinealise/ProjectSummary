//
//  NSObject+ChangeState.m
//  LiChuan
//
//  Created by zhanshu-叶国帅 on 15/5/21.
//  Copyright (c) 2015年 zhanshu. All rights reserved.
//

#import "NSObject+ChangeState.h"

@implementation NSObject (ChangeState)
-(NSString*)safeString
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }else
        return (NSString*)self;
}
-(NSString *)changeToZero
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"0";
    }else
        return (NSString*)self;
}
-(NSString *)changeToZeroB
{
    if ([self isKindOfClass:[NSNull class]]) {
        return @"0%";
    }else
        return (NSString*)self;
}
@end
