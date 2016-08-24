//
//  BaseViewController.m
//  bus
//
//  Created by ygs on 15/6/6.
//  Copyright (c) 2015年 ygs. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIView *myView;
    UIView *requestFailView;//连接服务器失败的页面
    UIButton *requestBtn;
    //BOOL isHasBottom;
}

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [self initNavBar];

}

- (void)initNavBar
{
    _navBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    _navBar.hidden=YES;
    _navBar.backgroundColor = TitleColor;
    [self.view addSubview:_navBar];
    
    _titleLable=[[UILabel alloc]initWithFrame:CGRectMake(40, 20,ScreenWidth-80, 44)];
    _titleLable.backgroundColor=[UIColor clearColor];
    //_titleLable.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLable.textAlignment=NSTextAlignmentCenter;
    _titleLable.font=[UIFont boldSystemFontOfSize:18];
    _titleLable.textColor=[UIColor whiteColor];
    [_navBar addSubview:_titleLable];
}

//返回按钮 返回首页
- (void)addNavView:(NSString*)title doBack:(BOOL)doBack andHasRight:(BOOL)doRight {
    _navBar.hidden=NO;
    _titleLable.text=title;
    if (doBack) {
        _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame=CGRectMake(10, 35, 9, 16);
        [_backBtn setImage:[UIImage imageNamed:@"14商户管理-营业状况_003.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-15, -15, -15, -15)];
        [_navBar addSubview:_backBtn];
    }
    
    if (doRight) {
        _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame=CGRectMake(ScreenWidth- 25, 20+15, 17, 17);
        [_rightBtn setNormalImageWith:@"1订单_05.png"];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-30, -30, -30, -30)];
        [_navBar addSubview:_rightBtn];
    }

}

- (void)initNavBarBackHome{
    _navBar.hidden=NO;
    [self.navigationController.navigationBar setBarTintColor:TitleColor];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(ScreenWidth-44, 0, 44, 4)];
    [backButton addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"icon_rightBtn_3x.png"] forState:UIControlStateNormal];
    [backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem =backItem;
}

- (void)backAction:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightBtnAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 将tabbar隐藏的push
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
}

-(void)alertTextBoxMesg:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = [UIFont systemFontOfSize:13];
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.5];
}

#pragma mark----网络请求方法
//get网络请求
-(void)getRequestValue:(NSDictionary *)myParam andRequestUrl:(NSString *)requestUrl andMethods:(NTRequestMethod)methods callBackBlock:(void(^)(id value ,int success,NSError *error))complate{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"加载中...";
    [NTNetUtil sendRequestWithUrl:requestUrl requestName:@"" method:methods parameters:myParam block:^(NTHttpRequest *networkRequest, NSError *error) {
        if (!error) {
             [_hud hideAnimated:YES];
            NSDictionary *resultDic = networkRequest.responseData;
            complate(resultDic,[[resultDic objectForKey:@"states"]intValue],nil);
        }else{
            _hud.mode = MBProgressHUDModeText;
            _hud.label.text = @"网络连接出现错误";
            [_hud hideAnimated:YES afterDelay:1.5];
             complate(nil,-1,error);
        }
    }];
}

//post网络请求
- (void)postImgRequestValue:(NSDictionary *)myParam andRequestUrl:(NSString *)requestUrl andMImgArr:(NSArray *)imgArr callBackBlock:(void(^)(id value,int success,NSError *error))complate {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"加载中...";
    [NTNetUtil postImgWithParam:myParam requestUrl:requestUrl dataArr:imgArr block:^(NTHttpRequest *networkRequest, NSError *error) {
        if (!error) {
            [_hud hideAnimated:YES];
            NSDictionary *resultDic = networkRequest.responseData;
            complate(resultDic,[[resultDic objectForKey:@"states"]intValue],nil);
        }else{
            _hud.mode = MBProgressHUDModeText;
            _hud.label.text = @"网络连接出现错误";
            [_hud hideAnimated:YES afterDelay:1.5];
            complate(nil,-1,error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
