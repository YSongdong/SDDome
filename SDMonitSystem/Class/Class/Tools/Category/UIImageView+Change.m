//
//  UIImageView+Change.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/31.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UIImageView+Change.h"

@implementation UIImageView (Change)

+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString *)str
{
    NSURL *url =  [NSURL URLWithString:str];
    
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"cover"]options:SDWebImageRetryFailed];

}
@end
