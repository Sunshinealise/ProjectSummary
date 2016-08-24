//
//  JsWebviewNativeManager.m
//  LazyCat
//
//  Created by zhanshu on 15/9/16.
//  Copyright (c) 2015年 zhanshu. All rights reserved.
//

#import "JsWebviewNativeManager.h"

@implementation JsWebviewNativeManager
+ (BOOL)theRequestUrl:(NSString *)requestString viewController:(id)VC success:(Success)success {
    NSLog(@"++++++my++++%@",requestString);
    NSArray *components = [requestString componentsSeparatedByString:@"@"];//提交请求时候分割参数的分隔符
    if (components.count == 2) {
        NSArray *resultArr = [components[1] componentsSeparatedByString:@":"];
        if ([resultArr count] > 1 && [(NSString *)[resultArr objectAtIndex:0] isEqualToString:@"aoup_ios"]) {
            //过滤请求是否是我们需要的.不需要的请求不进入条件
            NSString *actionStr = [resultArr objectAtIndex:1];
            if ([actionStr isEqualToString:@"toCart"]) {
                NSString *ID = [resultArr objectAtIndex:2];
                success(showToCart,ID,@"");
            }else if ([actionStr isEqualToString:@"tel"]){
                NSString *tel = [resultArr objectAtIndex:2];
                success(showPhoneCall,tel,@"");
            }else if([actionStr isEqualToString:@"showMessage"]){
                NSString *msgage = [resultArr objectAtIndex:2];
                success(showMessage,msgage,@"");
            }
            
//            if([actionStr isEqualToString:@"addReview"])
//            {
//                NSString *ID = [resultArr objectAtIndex:2];
//                //通知跳转至原生界面
//                success(addReview,ID,@"");
//            }else if ([actionStr isEqualToString:@"updateProfile"]){
//                
//                success(updateProfile,@"",@"");
//            }else if ([actionStr isEqualToString:@"tel"]){
//                NSString *ID = [resultArr objectAtIndex:2];
//                success(tel,ID,@"");
//            }else if ([actionStr isEqualToString:@"showMessage"]){
//                //NSString *ID = [Utils URLDecodedString:[resultArr objectAtIndex:2]];
//                //success(showMessage,ID,@"");
//            }else if ([actionStr isEqualToString:@"toLogin"]){
//                success(toLogin,@"",@"");
//            }else if ([actionStr isEqualToString:@"toConsultationContent"]){
//                NSString *ID = [resultArr objectAtIndex:2];
//                NSArray * arr = [ID componentsSeparatedByString:@","];
////                NSString *Path = [resultArr objectAtIndex:3];
//                success(toConsultationContent,[arr objectAtIndex:0],[arr objectAtIndex:1]);
//            }
            return NO;
        }
    }
    return YES;
}

@end
