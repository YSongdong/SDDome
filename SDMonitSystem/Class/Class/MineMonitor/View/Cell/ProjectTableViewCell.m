//
//  ProjectTableViewCell.m
//  SDMonitSystem
//
//  Created by tiao on 2018/1/22.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ProjectTableViewCell.h"

@interface ProjectTableViewCell ()
//封面图
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
//设备名
@property (weak, nonatomic) IBOutlet UILabel *equiNameLab;
//是否在线
@property (weak, nonatomic) IBOutlet UIButton *onLineBtn;


@end


@implementation ProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.onLineBtn.layer.cornerRadius = 17.5;
    self.onLineBtn.layer.masksToBounds = YES;
    
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    //设备名
    self.equiNameLab.text = dict[@"name"];
    
    //封面
    [UIImageView sd_setImageView:self.coverImageView WithURL:dict[@"header_img"]];
    
    //判断是否在线
    if ([dict[@"online"]integerValue] == 1 ) {
        //在线
        [self.onLineBtn setTitle:@"在线" forState:UIControlStateNormal];
        
    }else{
        
        [self.onLineBtn setTitle:@"离线" forState:UIControlStateNormal];
        //离线
        self.coverImageView.image = [self changeGrayImage:self.coverImageView.image];
    }
    
}

//图片变灰
-(UIImage *)changeGrayImage:(UIImage *)oldImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = oldImage.size.width;
    int height = oldImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), oldImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
