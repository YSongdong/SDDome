//
//  ForgatPwdViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ForgatPwdViewController.h"
#import "HWWeakTimer.h"


@interface ForgatPwdViewController ()<UITextFieldDelegate>

//icon
@property (nonatomic,strong) UIImageView *iconImage;
//公司名字
@property (nonatomic,strong) UITextField *orgTF;
//登录账号
@property (nonatomic,strong) UITextField *loginNameTF;
//手机号
@property (nonatomic,strong) UITextField *iphoneNumberTF;
//发送验证码Btn
@property (nonatomic,strong) UIButton *sendBtn;
//验证码
@property (nonatomic,strong) UITextField *testTF;
//新密码
@property (nonatomic,strong) UITextField  *newpasswordTF;
//登录按钮
@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,assign) NSInteger timerPage; //显示时间
//记录userID
@property (nonatomic,strong) NSString *userID;
@end

@implementation ForgatPwdViewController{
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建UI
    [self initForgatUI];
    
    [self initNaviBar];
    
}
#pragma mark  -----按钮点击事件----
//确定按钮
-(void)tureBtnAction:(UIButton *)sender{
    //取消第一响应
    [self cacelResing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userid"] = self.userID;
    param[@"phone"] =  self.iphoneNumberTF.text;
    param[@"org_code"] = self.orgTF.text;
    param[@"code"] = self.testTF.text;
    param[@"password"] = self.newpasswordTF.text;
    param[@"username"] = self.loginNameTF.text;

    if (self.orgTF.text.length > 0) {
        if (self.loginNameTF.text.length > 0) {
            if (self.iphoneNumberTF.text.length > 10) {
                if (self.testTF.text.length > 0) {
                    if (self.newpasswordTF.text.length > 5) {
                        
                         [self requestForgetPwd:param.copy];
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
                        [SVProgressHUD dismissWithDelay:1];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                    [SVProgressHUD dismissWithDelay:1];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
                [SVProgressHUD dismissWithDelay:1];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入登录账号"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入单位代码"];
        [SVProgressHUD dismissWithDelay:1];
    }

}
//点击发送验证码按钮
-(void)sendBtnAction:(UIButton *) sender{
    //获取验证码
    [self.testTF  becomeFirstResponder];
    self.sendBtn.enabled = NO;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"org_code"] = self.orgTF.text;
    param[@"username"] = self.loginNameTF.text;
    param[@"phone"] = self.iphoneNumberTF.text;

    [self requestObtainTest:param.copy];
}
//时间实现方法
-(void)repeat
{
    if (self.timerPage > 0) {
        self.timerPage --;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%ld 重新发送",(long)self.timerPage] forState:UIControlStateNormal];
    }else{
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self cacelResing];
}
//取消第一响应
-(void) cacelResing{
    [self.orgTF resignFirstResponder];
    [self.loginNameTF resignFirstResponder];
    [self.iphoneNumberTF resignFirstResponder];
    [self.testTF resignFirstResponder];
    [self.newpasswordTF resignFirstResponder];
    
}
#pragma mark ---- UITextFeildDelegate---
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.testTF) {
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y -= 100;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }else if (textField == self.newpasswordTF){
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y -= 150;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.testTF) {
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y += 100;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }else if (textField == self.newpasswordTF){
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y += 150;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
}
//点击完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.orgTF resignFirstResponder];
    [self.loginNameTF resignFirstResponder];
    [self.iphoneNumberTF resignFirstResponder];
    [self.testTF resignFirstResponder];
    [self.newpasswordTF resignFirstResponder];

    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else if ([textField isEqual:self.newpasswordTF]) {
        return textField.text.length < 17;
    }
    else if ([textField isEqual:self.orgTF]) {
        return textField.text.length < 17;
    }
    else if ([textField isEqual:self.loginNameTF]) {
        return textField.text.length < 17;
    }
    else if ([textField isEqual:self.iphoneNumberTF]) {
        return textField.text.length < 11;
    }
    
    return YES;

}

//创建Navi
-(void) initNaviBar{
    
    [self customNaviItemTitle:@"忘记密码" titleColor:[UIColor blackColor]];
    [self customTabBarButtonimage:@"backBtn_black" target:self action:@selector(backBtnAction:) isLeft:YES];
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
-(void) initForgatUI{
    self.view.backgroundColor  =[UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    //icon
    self.iconImage = [[UIImageView alloc]init];
    [self.view addSubview:self.iconImage];
    
    self.orgTF = [[UITextField alloc]init];
    [self.view addSubview:self.orgTF];
    self.orgTF.delegate = self;
    
    self.loginNameTF = [[UITextField alloc]init];
    [self.view addSubview:self.loginNameTF];
    self.loginNameTF.delegate = self;
    
    self.iphoneNumberTF = [[UITextField alloc]init];
    [self.view addSubview:self.iphoneNumberTF];
    self.iphoneNumberTF.delegate = self;
    
    self.testTF = [[UITextField alloc]init];
    [self.view addSubview:self.testTF];
    self.testTF.delegate = self;
    self.testTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.newpasswordTF = [[UITextField alloc]init];
    [self.view addSubview:self.newpasswordTF];
    self.newpasswordTF.delegate = self;
    
    self.loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.loginBtn];
    
    //icon
    self.iconImage.image =[UIImage imageNamed:@"logo"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSIphonScreenH(42)+64);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.height.equalTo(@80);
    }];
    self.iconImage.layer.cornerRadius  =40;
    self.iconImage.layer.masksToBounds = YES;
    
    //公司名字
    self.orgTF.placeholder = @"单位代码";
    self.orgTF.layer.cornerRadius = 3;
    self.orgTF.layer.masksToBounds = YES;
    self.orgTF.clearButtonMode =UITextFieldViewModeAlways;
    self.orgTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.orgTF.returnKeyType = UIReturnKeyDone;
    self.orgTF.font = [UIFont systemFontOfSize:14];
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_org"]];
    UIView *leftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    leftImage.center = leftView.center;
    [leftView addSubview:leftImage];
    self.orgTF.leftViewMode = UITextFieldViewModeAlways;
    self.orgTF.leftView =leftView;
    [self.orgTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(KSIphonScreenH(50));
        make.left.equalTo(weakSelf.view).offset(KSIphonScreenW(30));
        make.right.equalTo(weakSelf.view).offset(-KSIphonScreenW(30));
        make.height.equalTo(@(KSIphonScreenH(50)));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    // 登录账号
    self.loginNameTF.placeholder = @"登录账号";
    self.loginNameTF.layer.cornerRadius = 3;
    self.loginNameTF.layer.masksToBounds = YES;
    self.loginNameTF.clearButtonMode =UITextFieldViewModeAlways;
    self.loginNameTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.loginNameTF.returnKeyType = UIReturnKeyDone;
    self.loginNameTF.font = [UIFont systemFontOfSize:14];
    UIImageView *loginLeftImage = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"login_name"]];
    UIView *loginleftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    loginLeftImage.center = loginleftView.center;
    [loginleftView addSubview:loginLeftImage];
    self.loginNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.loginNameTF.leftView =loginleftView;
    [self.loginNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.orgTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.orgTF.mas_left);
        make.height.width.equalTo(weakSelf.orgTF);
        make.centerX.equalTo(weakSelf.orgTF.mas_centerX);
    }];

    //手机号
    self.iphoneNumberTF.placeholder = @"输入手机号";
    self.iphoneNumberTF.layer.cornerRadius = 3;
    self.iphoneNumberTF.layer.masksToBounds = YES;
    self.iphoneNumberTF.clearButtonMode =UITextFieldViewModeAlways;
    self.iphoneNumberTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.iphoneNumberTF.returnKeyType = UIReturnKeyDone;
    self.iphoneNumberTF.font = [UIFont systemFontOfSize:14];
    UIImageView *iphoneLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_iphone"]];
    UIView *iphoneleftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    iphoneLeftImage.center = iphoneleftView.center;
    [iphoneleftView addSubview:iphoneLeftImage];
    self.iphoneNumberTF.leftViewMode = UITextFieldViewModeAlways;
    self.iphoneNumberTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.iphoneNumberTF.leftView =iphoneleftView;
    
    [self.iphoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginNameTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.loginNameTF.mas_left);
        make.height.width.equalTo(weakSelf.loginNameTF);
        make.centerX.equalTo(weakSelf.loginNameTF.mas_centerX);
    }];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 95, CGRectGetHeight(self.iphoneNumberTF.frame))];
    rightView.backgroundColor = [UIColor redColor];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@1);
        make.top.equalTo(weakSelf.iphoneNumberTF).offset(15);
        make.bottom.equalTo(weakSelf.iphoneNumberTF).offset(-15);
        make.right.equalTo(weakSelf.iphoneNumberTF).offset(-90);
    }];
    
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView addSubview:self.sendBtn];
    [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sendBtn setTitleColor:[UIColor colorWithHexString:@"#5a5b5b"] forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(KSIphonScreenW(80)));
        make.right.equalTo(rightView);
        make.height.equalTo(rightView.mas_height);
        make.centerY.equalTo(rightView.mas_centerY);
    }];
    self.iphoneNumberTF.rightViewMode =  UITextFieldViewModeAlways;
    self.iphoneNumberTF.rightView = self.sendBtn;
  
    //验证码
    self.testTF.placeholder = @"输入验证码";
    self.testTF.layer.cornerRadius = 3;
    self.testTF.layer.masksToBounds = YES;
    self.testTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.testTF.returnKeyType = UIReturnKeyDone;
    self.testTF.font = [UIFont systemFontOfSize:15];
    UIImageView *testLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_test"]];
    UIView *testleftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    testLeftImage.center = testleftView.center;
    [testleftView addSubview:testLeftImage];
    self.testTF.leftViewMode = UITextFieldViewModeAlways;
    self.testTF.leftView =testleftView;
    [self.testTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iphoneNumberTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.iphoneNumberTF.mas_left);
        make.height.width.equalTo(weakSelf.iphoneNumberTF);
        make.centerX.equalTo(weakSelf.iphoneNumberTF.mas_centerX);
    }];
    
    //新密码
    self.newpasswordTF.placeholder = @"输入新密码";
    self.newpasswordTF.layer.cornerRadius = 3;
    self.newpasswordTF.layer.masksToBounds = YES;
    self.newpasswordTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.newpasswordTF.returnKeyType = UIReturnKeyDone;
    self.newpasswordTF.font = [UIFont systemFontOfSize:14];
    UIImageView *pwdLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_pwd"]];
    UIView *pwdleftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    pwdLeftImage.center = pwdleftView.center;
    [pwdleftView addSubview:pwdLeftImage];
    self.newpasswordTF.leftViewMode = UITextFieldViewModeAlways;
    self.newpasswordTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.newpasswordTF.leftView =pwdleftView;
    self.newpasswordTF.secureTextEntry = YES;
    [self.newpasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.testTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.testTF.mas_left);
        make.height.width.equalTo(weakSelf.testTF);
        make.centerX.equalTo(weakSelf.testTF.mas_centerX);
    }];
    
    //确定按钮
    [self.loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor loginBtnBackGrounpColor];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.newpasswordTF.mas_bottom).offset(KSIphonScreenH(40));
        make.left.equalTo(weakSelf.newpasswordTF.mas_left);
        make.height.width.equalTo(weakSelf.newpasswordTF);
        make.centerX.equalTo(weakSelf.newpasswordTF.mas_centerX);
    }];
     [self.loginBtn addTarget:self action:@selector(tureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma  mark ---  数据相关-----
//确定按钮
-(void ) requestForgetPwd:(NSDictionary *)param{
    
    __weak typeof(self) weakSelf = self;
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemForgetPwd_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (!error) {
            NSNumber *code = showdata[@"code"];
            if ([code integerValue] == 0) {
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
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
//获取验证码
-(void) requestObtainTest:(NSDictionary *)param{
    __weak typeof(self) weakSelf = self;
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemTest_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (!error) {
            NSNumber *code = showdata[@"code"];
            if ([code integerValue] == 0) {
                [SVProgressHUD  showSuccessWithStatus:@"发送成功"];
                [SVProgressHUD  dismissWithDelay:1.5];
                
                NSDictionary *dict =showdata[@"data"];
                weakSelf.userID = dict[@"userid"];
                
                weakSelf.timerPage = 60;
                
                _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat)userInfo:nil repeats:YES];
                
            }else{
                weakSelf.sendBtn.enabled = YES;
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
