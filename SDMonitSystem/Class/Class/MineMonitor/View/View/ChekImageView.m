//
//  ChekImageView.m
//  SDMonitSystem
//
//  Created by tiao on 2018/3/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ChekImageView.h"



@interface ChekImageView ()
<
UIScrollViewDelegate
>
@property (nonatomic,strong)UIScrollView *scrollerView;

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong)   UIView *backView;
@property (assign, nonatomic) CGFloat scale;//记录上次手势结束的放大倍数
@property (assign, nonatomic) CGFloat realScale;//当前手势应该放大的倍数

@property (nonatomic,strong) UIView *bigBackView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *hpBtn;

@end


@implementation ChekImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void) createUI{
    __weak typeof(self) weakSelf = self;
    self.bigBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    self.bigBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bigBackView];
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [self.backView addGestureRecognizer:backTap];
    
    
    self.backBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigBackView addSubview:self.backBtn];
   // self.backBtn.backgroundColor = [UIColor redColor];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bigBackView).offset(30);
        make.left.equalTo(weakSelf.bigBackView).offset(20);
        make.width.height.equalTo(@30);
    }];
    [self.backBtn addTarget:self action:@selector(selectdBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.hpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigBackView addSubview:self.hpBtn];
   // self.hpBtn.backgroundColor = [UIColor redColor];
    [self.hpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(weakSelf.bigBackView).offset(240);
        make.right.equalTo(weakSelf.bigBackView).offset(-8);
        make.width.height.equalTo(@30);
    }];
    [self.hpBtn addTarget:self action:@selector(selectHPBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //背景view
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 280, KScreenW, KScreenH-280)];
    
    CGFloat viewWidth = self.backView.frame.size.width;
    CGFloat viewHeight = self.backView.frame.size.height;
    
    self.backView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [self.backView addGestureRecognizer:tap];
    
    self.scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, viewWidth, viewHeight-100)];
    [self.backView addSubview:self.scrollerView];
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.bounces = NO;
    self.scrollerView.delegate = self;
    self.scrollerView.showsHorizontalScrollIndicator = NO;

    
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, self.scrollerView.frame.size.height)];
        [self.scrollerView addSubview:imageView];
        imageView.userInteractionEnabled =YES;
        
        [Tool sd_setImageView:imageView WithURL:self.imageArr[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTap)];
        [imageView addGestureRecognizer:singleTap];
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
    }
   //滚动到指定位置
    [self.scrollerView setContentOffset:CGPointMake(self.index*viewWidth, 0) animated:YES];
    
    self.scrollerView.contentSize = CGSizeMake(self.imageArr.count*viewWidth, viewHeight-100);
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, viewHeight-40, viewWidth-40, 30)];
    self.pageControl.numberOfPages = self.imageArr.count;
    self.pageControl.currentPage = self.index;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorTintColor = [UIColor TableViewBackGrounpColor];        //设置未激活的指示点颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor tabBarItemTextColor];
    [self.backView addSubview:_pageControl];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    int index = scrollView.contentOffset.x / KScreenW ;
    
    self.pageControl.currentPage = index;
    
}


-(void)selectTap{
    
    [self removeFromSuperview];
}
- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)pinch
{
    UIImageView *imageView =(UIImageView*) pinch.view;
    
    if (self.realScale > 10) {//设置最大放大倍数
        self.realScale = 2;
    }else if (self.realScale < 0.5){//最小放大倍数
        self.realScale = 0.5;
    }
    
    imageView.transform = CGAffineTransformMakeScale(self.realScale, self.realScale);
    
    if (pinch.state == UIGestureRecognizerStateEnded){//当结束捏合手势时记录当前图片放大倍数
        
        self.scale = self.realScale;
        
    }
}

#pragma mark  ---- btn
-(void)selectdBackBtnAction:(UIButton *) sender{
    
    [self selectTap];
    
    self.btnBlock(YES);
}
-(void)selectHPBtnAction:(UIButton *) sender{
    
    [self selectTap];
    
    self.btnBlock(NO);
}

-(NSArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [NSArray array];
    }
    return _imageArr;
}

@end
