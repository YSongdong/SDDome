//
//  SetFunctionView.h
//  SDMonitSystem
//
//  Created by tiao on 2018/1/23.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetFunctionView : UIView


-(instancetype)initWithFrame:(CGRect)frame leftImage:(NSString *)leftImage andTitle:(NSString*)title andTarget:(id)target andAction:(SEL)action andTag:(NSInteger)tag;
@end
