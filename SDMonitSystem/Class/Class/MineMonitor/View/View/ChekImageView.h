//
//  ChekImageView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/3/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChekImageView : UIView

//YEs 是返回  NO 横屏
@property (nonatomic,copy) void(^btnBlock)(BOOL isBack);

@property(nonatomic,strong) NSArray *imageArr;

@property (nonatomic,assign) NSInteger index;

-(void) createUI;



@end
