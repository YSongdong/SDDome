//
//  NaviTitleView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviTitleView : UIView

//项目名字
@property (nonatomic,strong) UILabel *equiNameLab;

@property(nonatomic, assign) CGSize intrinsicContentSize;

@property (nonatomic,copy) void(^titleViewBlock)(UIButton *sender);



@end
