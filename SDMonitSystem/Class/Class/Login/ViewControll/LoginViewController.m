//
//  LoginViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "LoginViewController.h"

#import "ForgatPwdViewController.h"

#import "CustTableBarController.h"
#import "AppDelegate.h"
@interface LoginViewController ()<UITextFieldDelegate>

//icon
@property (nonatomic,strong) UIImageView *iconImage;
//公司名字
@property (nonatomic,strong) UITextField *orgTF;
//登录账号
@property (nonatomic,strong) UITextField *loginTF;
//登录密码
@property (nonatomic,strong) UITextField *passwdTF;
//忘记密码
@property (nonatomic,strong) UIButton *forgetBtn;
//登录按钮
@property (nonatomic,strong) UIButton *loginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建UI
    [self initLoginUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserInfo passLoginData]) {
        [self loadData];
    }
     self.navBarBgAlpha = @"0.0";
}
//加载登录信息
-(void) loadData{
    //获取用户信息
    NSDictionary *dict= [UserInfo obtainLoadData];
   // self.orgTF.text = dict[@"org_code"];
    self.loginTF.text = dict[@"username"];
}
#pragma mark -----按钮点击事件---
//确定按钮
-(void)loginBtnAction:(UIButton *) sender{
    [self resignFirs];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"org_code"] = self.orgTF.text;
    param[@"username"] =  self.loginTF.text;
    param[@"password"] = self.passwdTF.text;
    
    
    if (self.loginTF.text.length > 0) {
        if (self.passwdTF.text.length > 0) {
            
                [self requestLoginData:param.mutableCopy];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入登录账号"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
}
//忘记密码
-(void) selectdForgetBtnAction:(UIButton *)sender{
    [self.passwdTF resignFirstResponder];
   // [self textFieldDidEndEditing:self.passwdTF];
    ForgatPwdViewController *forgatVC = [[ForgatPwdViewController alloc]init];
    [self.navigationController pushViewController:forgatVC animated:YES];
}
//是否开启明文显示
-(void)unShowBtnAction:(UIButton *) sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
         self.passwdTF.secureTextEntry = YES;
    }else{
         self.passwdTF.secureTextEntry = NO;
    }
}
-(void)resignFirs{
    [self.passwdTF resignFirstResponder];
    [self.orgTF resignFirstResponder];
    [self.loginTF resignFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passwdTF resignFirstResponder];
    [self.orgTF resignFirstResponder];
    [self.loginTF resignFirstResponder];
}
#pragma mark ---UITextFeildDelegate ----
//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.passwdTF) {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= 100 ;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
}
//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.passwdTF) {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += 100 ;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
}
//点击完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self resignFirs];
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else if ([textField isEqual:self.passwdTF]) {
        return textField.text.length < 17;
    }
    else if ([textField isEqual:self.orgTF]) {
        return textField.text.length < 17;
    }
    else if ([textField isEqual:self.loginTF]) {
        return textField.text.length < 17;
    }
    return YES;
}
#pragma mark  -----创建UI-------
//创建UI
-(void) initLoginUI{
    
    self.view.backgroundColor  =[UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    //icon
    self.iconImage = [[UIImageView alloc]init];
    [self.view addSubview:self.iconImage];
    
    self.orgTF = [[UITextField alloc]init];
    [self.view addSubview:self.orgTF];
    self.orgTF.delegate = self;
    
    self.loginTF = [[UITextField alloc]init];
    [self.view addSubview:self.loginTF];
    self.loginTF.delegate = self;
    
    self.passwdTF = [[UITextField alloc]init];
    [self.view addSubview:self.passwdTF];
    self.passwdTF.delegate = self;
    
    self.forgetBtn = [[UIButton alloc]init];
    [self.view addSubview:self.forgetBtn];
    
    self.loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.loginBtn];
    
    self.iconImage.image =[UIImage imageNamed:@"logo"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSIphonScreenH(58)+64);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.height.equalTo(@100);
    }];
    self.iconImage.layer.cornerRadius  =50;
    self.iconImage.layer.masksToBounds = YES;
    
    UILabel *lab = [[UILabel alloc]init];
    [self.view addSubview:lab];
    lab.textColor = [UIColor tabBarItemTextColor];
    lab.font = [UIFont systemFontOfSize:17];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(KSIphonScreenH(20));
        make.centerX.equalTo(weakSelf.iconImage.mas_centerX);
    }];
    //获取本地软件的版本号
    NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    lab.text = [NSString stringWithFormat:@"云时际V%@",localVersion];
    
//    //公司名字
//    self.orgTF.placeholder = @"单位代码";
//    self.orgTF.layer.cornerRadius = 3;
//    self.orgTF.layer.masksToBounds = YES;
//    self.orgTF.clearButtonMode =UITextFieldViewModeAlways;
//    self.orgTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
//    self.orgTF.returnKeyType = UIReturnKeyDone;
//    self.orgTF.font = [UIFont systemFontOfSize:14];
//    self.orgTF.leftViewMode = UITextFieldViewModeAlways;
//    self.orgTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
//    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_org"]];
//    UIView *orgLeftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
//    leftImage.center = orgLeftView.center;
//    [orgLeftView addSubview:leftImage];
//    self.orgTF.leftView =orgLeftView;
//    [self.orgTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(KSIphonScreenH(75));
//        make.left.equalTo(weakSelf.view).offset(30);
//        make.right.equalTo(weakSelf.view).offset(-30);
//        make.height.equalTo(@(KSIphonScreenH(50)));
//        make.centerX.equalTo(weakSelf.view.mas_centerX);
//    }];
   
    //登录名
    self.loginTF.placeholder = @"登录账户";
    self.loginTF.layer.cornerRadius = 3;
    self.loginTF.layer.masksToBounds = YES;
    self.loginTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.loginTF.returnKeyType = UIReturnKeyDone;
    self.loginTF.clearButtonMode =UITextFieldViewModeAlways;
    self.loginTF.font = [UIFont systemFontOfSize:14];
    UIImageView *loginLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_name"]];
    UIView *loginLeftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    loginLeftImage.center = loginLeftView.center;
    [loginLeftView addSubview:loginLeftImage];
    self.loginTF.leftViewMode = UITextFieldViewModeAlways;
    self.loginTF.leftView =loginLeftView;
    self.loginTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.loginTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(KSIphonScreenH(75));
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.height.equalTo(@(KSIphonScreenH(50)));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    //密码
    self.passwdTF.placeholder = @"登录密码";
    self.passwdTF.layer.cornerRadius = 3;
    self.passwdTF.layer.masksToBounds = YES;
    self.passwdTF.delegate = self;
    self.passwdTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.passwdTF.returnKeyType = UIReturnKeyDone;
    self.passwdTF.font = [UIFont systemFontOfSize:14];
    UIImageView *passLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pwd"]];
    UIView *passLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    passLeftImage.center = passLeftView.center;
    [passLeftView addSubview:passLeftImage];
    self.passwdTF.leftView =passLeftView;
    self.passwdTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    [rightBtn setImage:[UIImage imageNamed:@"login_isShowPwd"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(unShowBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *passrightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    rightBtn.center = passrightView.center;
    [passrightView addSubview:rightBtn];
    self.passwdTF.rightView = passrightView;
    self.passwdTF.rightViewMode = UITextFieldViewModeAlways;
    self.passwdTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.passwdTF.secureTextEntry = YES;
    [self.passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.loginTF.mas_left);
        make.height.width.equalTo(weakSelf.loginTF);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
//    //忘记密码按钮
//    [self.forgetBtn  setTitle:@"忘记密码" forState:UIControlStateNormal];
//    self.forgetBtn.backgroundColor = [UIColor logintextFeildBackGrounpColor];
//    [self.forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.forgetBtn.layer.cornerRadius = 3;
//    self.forgetBtn.layer.masksToBounds = YES;
//    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.passwdTF.mas_bottom).offset(KSIphonScreenH(10));
//        make.right.equalTo(weakSelf.passwdTF);
//        make.width.equalTo(@(KSIphonScreenW(80)));
//        make.height.equalTo(@(KSIphonScreenH(30)));
//    }];
//    [self.forgetBtn addTarget:self action:@selector(selectdForgetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //确定按钮
    [self.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font  = [UIFont systemFontOfSize:17];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor loginBtnBackGrounpColor];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwdTF.mas_bottom).offset(KSIphonScreenH(50));
        make.left.equalTo(weakSelf.loginTF.mas_left);
        make.height.width.equalTo(weakSelf.loginTF);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    [self.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma  mark ---  数据相关-----
-(void ) requestLoginData:(NSDictionary *)param{
    __weak typeof(self) weakSelf =  self;
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemLogin_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (!error) {
            NSNumber *code = showdata[@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *dict = showdata[@"data"];
                // 保存用户信息
                [UserInfo saveData:dict];
                
                //保存用户名字和密码
                NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
                userDict[@"username"] =weakSelf.loginTF.text;
                userDict[@"password"] = weakSelf.passwdTF.text;
                [userd setObject:userDict forKey:@"User"];
                
                
                //否则直接进入应用
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                CustTableBarController *custTabVC = [sb instantiateViewControllerWithIdentifier:@"CustTableBarController"];
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appdel.window.rootViewController =custTabVC;
                
            }else{
                
                [SVProgressHUD  showErrorWithStatus:showdata[@"msg"]];
                [SVProgressHUD  dismissWithDelay:1];
            }
        }else{
            [SVProgressHUD  showErrorWithStatus:error];
            [SVProgressHUD  dismissWithDelay:1];
        }
    }];
}

@end
