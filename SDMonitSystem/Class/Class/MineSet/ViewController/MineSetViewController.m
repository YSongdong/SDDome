//
//  MineSetViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/23.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "MineSetViewController.h"

#import "AlterPwdViewController.h"
#import "AboutOurViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RootNaviController.h"

#import "SetLogoView.h"
#import "SetFunctionView.h"


@interface MineSetViewController ()<UINavigationControllerDelegate>

@end

@implementation MineSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建Navi
    [self initNaviBar];
    //创建UI
    [self initSetView];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
//创建Navi
-(void) initNaviBar{
    
    [self customNaviItemTitle:@"设置" titleColor:[UIColor whiteColor]];
    [self customTabBarButtonimage:@"back_wither" target:self action:@selector(backBtnAction:) isLeft:YES];
    [self getSub:self.navigationController.navigationBar andLevel:1];

}

// 获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    if ([subviews count] == 0) return;
    for (UIView *subview in subviews) {
        
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        [self getSub:subview andLevel:(level+1)];
        
    }
}
-(void)backBtnAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
// 创建UI
-(void)initSetView{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    SetLogoView *setlogoView = [[SetLogoView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KSIphonScreenH(209))];
    [self.view addSubview:setlogoView];
    
    NSArray *nameArr = @[@"检查更新",@"清除缓存",@"关于我们"];
    NSArray *imageArr = @[@"project_updata",@"project_delSave",@"project_about"];
    
    for (int i=0; i<3; i++) {
        NSInteger tag = 100+i;
        SetFunctionView *functionView = [[SetFunctionView alloc]initWithFrame:CGRectMake(0, 64+CGRectGetHeight(setlogoView.frame)+i*KSIphonScreenH(60), KScreenW, KSIphonScreenH(60)) leftImage:imageArr[i] andTitle:nameArr[i] andTarget:self andAction:@selector(btnActon:) andTag:tag];
        [self.view addSubview:functionView];
    }
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(setlogoView.frame)+3*KSIphonScreenH(60)+64, KScreenW, KScreenH-CGRectGetHeight(setlogoView.frame)-3*KSIphonScreenH(60)-64)];
    [self.view addSubview:view];
    view.backgroundColor =[UIColor whiteColor];
    
    
    __weak typeof(self) weakSelf = self;
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:trueBtn];
    [trueBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font =[UIFont  systemFontOfSize:17];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KSIphonScreenH(50)));
        make.top.equalTo(setlogoView.mas_bottom).offset(KSIphonScreenH(270));
        make.right.equalTo(weakSelf.view).offset(-10);
        make.left.equalTo(weakSelf.view).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    trueBtn.layer.cornerRadius = 3;
    trueBtn.layer.masksToBounds = YES;
    trueBtn.backgroundColor = [UIColor colorWithHexString:@"#dcdcdc"];
    [trueBtn addTarget:self action:@selector(loginoutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -------按钮点击事件------
-(void)btnActon:(UIButton *) sender{
    switch (sender.tag-100) {
    
        case 0:
            //检查更新
           // [self checkVersion];
            [SVProgressHUD showSuccessWithStatus:@"最新版本"];
            [SVProgressHUD dismissWithDelay:0.5];

            break;
        case 1:
        {
            [[SDImageCache sharedImageCache]clearDiskOnCompletion:nil];
            [SVProgressHUD showSuccessWithStatus:@"清除成功"];
            [SVProgressHUD dismissWithDelay:0.5];
            break;
             }
        case 2:
        {
            //关于我们
            self.hidesBottomBarWhenPushed = YES;
            AboutOurViewController *aboutVC = [[AboutOurViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
            break;
        }
        default:
            break;
    }
}
//登出
-(void)loginoutBtnAction:(UIButton *)sender{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"org_code"] = [UserInfo obtainWithMarks];
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemLoginOut_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error];
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        NSNumber *code = showdata[@"code"];
        if ([code integerValue] == 0) {
           
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            RootNaviController *naviVC = [[RootNaviController alloc]initWithRootViewController:loginVC];
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appdel.window.rootViewController =naviVC;
            
        }else{
            [SVProgressHUD showErrorWithStatus:showdata[@"msg"]];
            [SVProgressHUD dismissWithDelay:1];
        }
    }];
}
//检查更新
-(void)checkVersion
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1351647201"];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
   // NSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取本地软件的版本号
    NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
   //  NSLog(@"localVersion版本号是：%@",localVersion);
    
    NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@，发现新版本V%@，是否下载新版本？",localVersion,newVersion];
    
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = json[@"results"];
        
        for (NSDictionary *dic in array) {
            
            newVersion = [dic valueForKey:@"version"];
        }
        
        //对比发现的新版本和本地的版本
        if ([newVersion floatValue] > [localVersion floatValue])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E4%BA%91%E6%97%B6%E9%99%85/id1351647201?mt=8"]];
                //这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              
            }]];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"最新版本"];
            [SVProgressHUD dismissWithDelay:0.5];
        }
    }
    
}

@end
