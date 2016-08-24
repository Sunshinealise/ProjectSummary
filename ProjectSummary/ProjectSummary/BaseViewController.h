//
//  BaseViewController.h
//  bus
//
//  Created by ygs on 15/6/6.
//  Copyright (c) 2015年 ygs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pageRequestFailDelegate <NSObject>

-(void)requestPageFailBtnAction;

@end

@interface BaseViewController : UIViewController
@property (strong, nonatomic) UIView *navBar;
@property (strong, nonatomic) UIButton *rightBtn;//右边按钮
@property (strong, nonatomic) UILabel *titleLable;//标题
@property (strong, nonatomic) UIButton *backBtn;//返回按钮
@property (nonatomic, strong) MBProgressHUD *hud;

@property (assign, nonatomic) BOOL isHasBottom;
@property (assign, nonatomic) id<pageRequestFailDelegate>baseDelegate;

/**左侧带有返回按钮和right键*/
-(void)addNavView:(NSString*)title doBack:(BOOL)doBack andHasRight:(BOOL)doRight;

/** 返回分目录*/
-(void)initNavBarBackHome;

/**提示框*/
-(void)alertTextBoxMesg:(NSString *)msg;

/**页面跳转*/
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

//get网络请求
-(void)getRequestValue:(NSDictionary *)myParam andRequestUrl:(NSString *)requestUrl andMethods:(NTRequestMethod)methods callBackBlock:(void(^)(id value ,int success,NSError *error))complate;
//post网络请求
-(void)postImgRequestValue:(NSDictionary *)myParam andRequestUrl:(NSString *)requestUrl andMImgArr:(NSArray *)imgArr callBackBlock:(void(^)(id value,int success,NSError *error))complate;

@end
