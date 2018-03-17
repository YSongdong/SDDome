//
//  AboutOurViewController.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/23.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "AboutOurViewController.h"

@interface AboutOurViewController ()

@property (nonatomic,strong) UITextView *textView;

@end

@implementation AboutOurViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self initNaviBar];
    [self initTextView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";
}

-(void) initTextView{
    self.textView =[[UITextView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64)];
    [self.view addSubview:self.textView];
    
    self.textView.font = [UIFont systemFontOfSize:16];
    //self.textView.textAlignment= NSTextAlignmentCenter;
    self.textView.text = @"\n     云时际人工智能监控云平台，是以人工智能技术为基础，实现远程时刻监管安全作业过程，并对违规操作进行识别和判断的智能操作系统。\n\n      云时际隶属于重庆览辉信息技术有限公司，企业创办于2016年，注册资金1000万，团队人数30余人，是一家致力于中国电力行业分类信息共享和人工智能产品研发的技术公司。以专业的态度和深厚的技术实力，深挖电力工程需求，积极开发互联网科技与电力行业结合潜力，自主研发项目建设管控、施工人员管理、线上教育培训等功能，以此为基础，逐步研发、完善延伸深化功能，同时进行平台功能整合，打造互联网云时代电力行业新起点。公司旗下主营产品有干电力网、电力聘、电力商城、安管控等相关品牌。\n\n  官方网站:  www.gandianli.com\n\n  客服微信:  gandianli008 \n\n  客服热线:  023-86188289\n\n  微信公众号:  gandianli";
    
    self.textView.editable = NO;
}

//创建Navi
-(void) initNaviBar{
    
    [self customNaviItemTitle:@"关于我们" titleColor:[UIColor whiteColor]];
    [self customTabBarButtonimage:@"back_wither" target:self action:@selector(backBtnAction:) isLeft:YES];
 
}
-(void)backBtnAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
