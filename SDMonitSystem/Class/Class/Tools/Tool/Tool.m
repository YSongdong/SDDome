//
//  Tool.m
//  SDMonitSystem
//
//  Created by tiao on 2018/2/2.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "Tool.h"

@implementation Tool
//加载网络图片
+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString *)str
{
    NSURL *url =  [NSURL URLWithString:str];
    
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cover"]options:SDWebImageRetryFailed];
    
}


@end
