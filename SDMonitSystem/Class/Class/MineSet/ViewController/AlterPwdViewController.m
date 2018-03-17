//
//  AlterPwdViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/23.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "AlterPwdViewController.h"

#import "LoginViewController.h"
#import "RootNaviController.h"
#import "AppDelegate.h"


@interface AlterPwdViewController () <UITextFieldDelegate>
//旧密码
@property (nonatomic,strong) UITextField *oldPwdTF;
//新密码
@property (nonatomic,strong) UITextField *NewPwdTF;
//确定密码
@property (nonatomic,strong) UITextField *truePwdTF;
//确定按钮
@property (nonatomic,strong) UIButton *trueBtn;
@end

@implementation AlterPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNaviBar];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}
#pragma mark ---UITextFeildDelegate ----
//点击完成按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.oldPwdTF resignFirstResponder];
    [self.NewPwdTF resignFirstResponder];
    [self.truePwdTF resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.oldPwdTF resignFirstResponder];
    [self.NewPwdTF resignFirstResponder];
    [self.truePwdTF resignFirstResponder];
}
#pragma mark ----按钮点击事件
//返回事件
-(void)selectBackBtnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
// 确定按钮
-(void)alterBtnAction:(UIButton *) sender{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"oldpassword"] = self.oldPwdTF.text;
    param[@"password"] =  self.NewPwdTF.text;
    param[@"password2"] = self.truePwdTF.text;
   // param[@"userid"] = [UserInfo obtainWithUserID];
    
    if (self.NewPwdTF.text.length > 0) {
        if (self.truePwdTF.text.length > 0) {
            
            if ([self.NewPwdTF.text isEqualToString:self.truePwdTF.text]) {
                
                [self requestAlterPwd:param.copy];
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"确认密码不一致！"];
                [SVProgressHUD dismissWithDelay:1];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请再次输入密码!"];
            [SVProgressHUD dismissWithDelay:1];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        [SVProgressHUD dismissWithDelay:1];
    }
    
//    if ([self.NewPwdTF.text isEqualToString:self.truePwdTF.text]) {
//
//         [self requestAlterPwd:param.copy];
//    }else{
//
//        [SVProgressHUD showErrorWithStatus:@"请再次输入密码!"];
//        [SVProgressHUD dismissWithDelay:1];
//    }
    
   
}
#pragma mark -----UITextFeildDelegate----
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.oldPwdTF) {
        if (self.oldPwdTF.text.length > 17) {
            
            return NO;
        }
    }
    if (textField == self.NewPwdTF) {
        if (self.NewPwdTF.text.length > 17) {
            
            return NO;
        }
    }
    if (textField == self.truePwdTF) {
        if (self.truePwdTF.text.length > 17) {
            
            return NO;
        }
    }
    return YES;
    
}

#pragma mark ----创建UI-----

//创建Navi
-(void) initNaviBar{
    
    [self customNaviItemTitle:@"修改密码" titleColor:[UIColor whiteColor]];
    [self customTabBarButtonimage:@"back_wither" target:self action:@selector(backBtnAction:) isLeft:YES];
    
}
-(void)backBtnAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) initUI{
    self.view.backgroundColor  =[UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    
    self.oldPwdTF = [[UITextField alloc]init];
    [self.view addSubview:self.oldPwdTF];
    self.oldPwdTF.delegate = self;
    
    self.NewPwdTF = [[UITextField alloc]init];
    [self.view addSubview:self.NewPwdTF];
    self.NewPwdTF.delegate = self;
    
    self.truePwdTF = [[UITextField alloc]init];
    [self.view addSubview:self.truePwdTF];
    self.truePwdTF.delegate = self;
    
    self.trueBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.trueBtn];
    
    //旧密码
    self.oldPwdTF.placeholder = @"请输入旧密码";
    self.oldPwdTF.layer.cornerRadius = 3;
    self.oldPwdTF.layer.masksToBounds = YES;
    self.oldPwdTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.oldPwdTF.returnKeyType = UIReturnKeyDone;
    self.oldPwdTF.font = [UIFont systemFontOfSize:14];
    UIImageView *oldLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_oldPwd"]];
    UIView *oldLeftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    oldLeftImage.center = oldLeftView.center;
    [oldLeftView addSubview:oldLeftImage];
    self.oldPwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.oldPwdTF.leftView =oldLeftView;
    self.oldPwdTF.secureTextEntry = YES;
    self.oldPwdTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.oldPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSIphonScreenH(130));
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.height.equalTo(@(KSIphonScreenH(50)));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    //新密码
    self.NewPwdTF.placeholder = @"请输入6-18位新密码";
    self.NewPwdTF.layer.cornerRadius = 3;
    self.NewPwdTF.layer.masksToBounds = YES;
    self.NewPwdTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.NewPwdTF.returnKeyType = UIReturnKeyDone;
    self.NewPwdTF.font = [UIFont systemFontOfSize:14];
    UIImageView *passLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_newPwd"]];
    UIView *passLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    passLeftImage.center = passLeftView.center;
    [passLeftView addSubview:passLeftImage];
    self.NewPwdTF.leftView =passLeftView;
    self.NewPwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.NewPwdTF.secureTextEntry = YES;
    [self.NewPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oldPwdTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.oldPwdTF.mas_left);
        make.height.width.equalTo(weakSelf.oldPwdTF);
        make.centerX.equalTo(weakSelf.oldPwdTF.mas_centerX);
    }];
    
    //确定密码
    self.truePwdTF.placeholder = @"请再次输入密码";
    self.truePwdTF.layer.cornerRadius = 3;
    self.truePwdTF.layer.masksToBounds = YES;
    self.truePwdTF.backgroundColor = [UIColor logintextFeildBackGrounpColor];
    self.truePwdTF.returnKeyType = UIReturnKeyDone;
    self.truePwdTF.font = [UIFont systemFontOfSize:14];
    UIImageView *trueLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"set_truePwd"]];
    UIView *trueLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    trueLeftImage.center = trueLeftView.center;
    [trueLeftView addSubview:trueLeftImage];
    self.truePwdTF.leftView =trueLeftView;
    self.truePwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.truePwdTF.secureTextEntry = YES;
    [self.truePwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.NewPwdTF.mas_bottom).offset(KSIphonScreenH(15));
        make.left.equalTo(weakSelf.NewPwdTF.mas_left);
        make.height.width.equalTo(weakSelf.NewPwdTF);
        make.centerX.equalTo(weakSelf.NewPwdTF.mas_centerX);
    }];
    
    //确定按钮
    [self.trueBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    self.trueBtn.titleLabel.font  = [UIFont systemFontOfSize:17];
    [self.trueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.trueBtn.backgroundColor = [UIColor loginBtnBackGrounpColor];
    self.trueBtn.layer.cornerRadius = 3;
    self.trueBtn.layer.masksToBounds = YES;
    [self.trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.truePwdTF.mas_bottom).offset(KSIphonScreenH(156));
        make.left.equalTo(weakSelf.truePwdTF.mas_left);
        make.height.width.equalTo(weakSelf.truePwdTF);
        make.centerX.equalTo(weakSelf.truePwdTF.mas_centerX);
    }];
    [self.trueBtn addTarget:self action:@selector(alterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma  mark ---  数据相关-----
-(void ) requestAlterPwd:(NSDictionary *)param{
    
    [[KRMainNetTool sharedKRMainNetTool] postRequstWith:SystemAlterPwd_URL params:param withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (!error) {
            NSNumber *code = showdata[@"code"];
            if ([code integerValue] == 0) {
                [SVProgressHUD  showSuccessWithStatus:@"修改成功"];
                [SVProgressHUD  dismissWithDelay:1.5];
                //延时2秒
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //登录界面
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    RootNaviController *naviVC = [[RootNaviController alloc]initWithRootViewController:loginVC];
                    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appdel.window.rootViewController =naviVC;
                });
                
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
