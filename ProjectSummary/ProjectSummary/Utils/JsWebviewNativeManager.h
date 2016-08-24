//
//  JsWebviewNativeManager.h
//  LazyCat
//
//  Created by zhanshu on 15/9/16.
//  Copyright (c) 2015年 zhanshu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JsWithWB) {
//   addReview,
//   updateProfile,
//   tel,
//   showMessage,
//   toLogin,
//   toConsultationContent
    showFavorite,
    showPhoneCall,
    showMessage,
    showToCart,
};

@interface JsWebviewNativeManager : NSObject

typedef void (^Success)(JsWithWB type,NSString *ID,NSString * pathUrl);

+ (BOOL)theRequestUrl:(NSString *)requestString viewController:(id)VC success:(Success)success;
@end
