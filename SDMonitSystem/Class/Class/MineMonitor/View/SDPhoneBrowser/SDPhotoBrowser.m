//
//  SDPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDBrowserImageView.h"

//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "SDPhotoBrowserConfig.h"

//  =============================================

@implementation SDPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
//    UILabel *_indexLabel;//暂时pageControl代替
    UIPageControl *_pageControl;
//    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
    
     UIView *_bigBackView;
    
    UIView *_backView;
    UIButton *_backBtn;
    UIButton *_hpBtn;
    //名称
    UILabel *_titleLab;
    //时间
    UILabel *_timeLab;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}


#pragma mark - Life
- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)setupScrollView
{

    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, self.frame.size.height)];
    _backView.backgroundColor = SDPhotoBrowserBackgrounColor;
    [self addSubview:_backView];
    

    _titleLab = [[UILabel alloc]init];
    [self addSubview:_titleLab];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:15];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView).offset(20);
        make.left.equalTo(_backView).offset(10);
        make.right.equalTo(_backView).offset(-10);
    }];
    
    _timeLab = [[UILabel alloc]init];
    [self  addSubview:_timeLab];
    _timeLab.font = [UIFont systemFontOfSize:13];
    _timeLab.textColor = [UIColor whiteColor];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(5);
        make.right.equalTo(_backView).offset(-10);
    }];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [_backView addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        SDBrowserImageView *imageView = [[SDBrowserImageView alloc] init];
        imageView.tag = i;
        
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [imageView addGestureRecognizer:singleTap];
        [imageView addGestureRecognizer:doubleTap];

        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}
- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
    
}
#pragma mark  ---- btn
-(void)selectdBackBtnAction:(UIButton *) sender{
    

    self.btnBlock(YES);
    
    [self removeFromSuperview];
    
}
-(void)selectHPBtnAction:(UIButton *) sender{
    
   self.btnBlock(NO);
    
   [self removeFromSuperview];
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    _titleLab.text = self.titleStr;
    _timeLab.text = self.timeStr;
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(SDBrowserImageView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
}

//是否已缓存原图
- (BOOL)hasHighQImage{
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    BOOL hasHighQImage = [manager diskImageExistsForURL:[self highQualityImageURLForIndex:self.currentImageIndex]];
    return NO;
}

//显示原图
- (void)showOriImage{
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[self highQualityImageURLForIndex:self.currentImageIndex].absoluteString];
    [self addSubview:tempView];
    CGRect targetTemp = _scrollView.subviews[self.currentImageIndex].bounds;
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
        
    }];

}

//显示缩略图
- (void)showThumbImage{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    
    [self addSubview:tempView];
    CGRect targetTemp = _scrollView.subviews[self.currentImageIndex].bounds;
    
    tempView.frame = rect;

    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
        
    }];

}
- (void)showFirstImage
{
    if ([self hasHighQImage]) {
        [self showOriImage];
    }
    else{
        [self showThumbImage];
    }
}



- (void)setupToolbars
{
    
    // 1. 序标
//    UILabel *indexLabel = [[UILabel alloc] init];
//    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
//    indexLabel.textAlignment = NSTextAlignmentCenter;
//    indexLabel.textColor = [UIColor whiteColor];
//    indexLabel.font = [UIFont boldSystemFontOfSize:16];
//    indexLabel.clipsToBounds = YES;
//    if (self.imageCount > 1) {
//        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
//    }
//    _indexLabel = indexLabel;
//    [self addSubview:indexLabel];
    
    if (self.imageCount > 1 )
    {
        UIPageControl *pCtrl = [[UIPageControl alloc] init];
        pCtrl.frame =  CGRectMake((self.bounds.size.width-60)/2, self.bounds.size.height-30, 80, 30);
        pCtrl.numberOfPages = self.imageCount;
        [self addSubview:pCtrl];
        pCtrl.pageIndicatorTintColor = [UIColor TableViewBackGrounpColor];        //设置未激活的指示点颜色
        pCtrl.currentPageIndicatorTintColor = [UIColor tabBarItemTextColor];
        _pageControl = pCtrl;
    }
   
}

- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    UIImageView *currentImageView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}
#pragma mark - Gesture
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    SDBrowserImageView *currentImageView = (SDBrowserImageView *)recognizer.view;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.image.size.width) * currentImageView.image.size.height;
    
    if (!currentImageView.image) { // 防止 因imageview的image加载失败 导致 崩溃
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];

    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
//        _indexLabel.alpha = 0.1;
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
       
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    SDBrowserImageView *imageView = (SDBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    SDBrowserImageView *view = (SDBrowserImageView *)recognizer.view;

    [view doubleTapToZommWithScale:scale];
}

#pragma mark - Public
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, SafeAreaHPNaviTopHeight+KSIphonScreenH(220), KScreenW, KScreenH-SafeAreaHPNaviTopHeight-KSIphonScreenH(220));
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        SDBrowserImageView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[SDBrowserImageView class]]) {
            [currentImageView clear];
        }
    }
}


#pragma mark - Private
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    
    SDBrowserImageView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    
    if ([self hasHighQImage]) {
        imageView.image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:[self highQualityImageURLForIndex:self.currentImageIndex].absoluteString];
    }
    else{
        if ([self highQualityImageURLForIndex:index]) {
            [imageView setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
        } else {
            imageView.image = [self placeholderImageForIndex:index];
        }

    }

    imageView.hasLoadedImage = YES;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    CGFloat distance = x - index * _scrollView.bounds.size.width;
    if (distance > margin || distance < - margin) {
        SDBrowserImageView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
//        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
        _pageControl.currentPage = index;
    }
    [self setupImageOfImageViewForIndex:index];
}



@end
