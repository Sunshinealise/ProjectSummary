//
//  NSDictionary+safeObjectForKey.m
//  MobileOA
//
//  Created by Lawrence Zhang on 12-8-29.
//
//

#import "NSDictionary+safeObjectForKey.h"

#define checkNull(__X__)        (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

@implementation NSDictionary (safeObjectForKey)

- (NSString *)safeObjectForKey:(id)key
{
    return checkNull([self objectForKey:key]);
}

@end
