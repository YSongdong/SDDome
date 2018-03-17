//
//  MonitorTableViewCell.m
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "MonitorTableViewCell.h"

@interface MonitorTableViewCell ()
//封面图
@property (weak, nonatomic) IBOutlet UIImageView *coveImageView;
//大标题
@property (weak, nonatomic) IBOutlet UILabel *bigTitleLab;
//小标题
@property (weak, nonatomic) IBOutlet UILabel *smallTitleLab;

@end


@implementation MonitorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.bigTitleLab.text = dict[@"Name"];
    
    //设备数量
    float  device_num = [dict[@"device_num"] integerValue];
    
//    if (device_num > 10000) {
//         self.smallTitleLab.text = [NSString stringWithFormat:@"设备数量:%.f万台",device_num/10000];
//    }else{
        self.smallTitleLab.text = [NSString stringWithFormat:@"设备数量:%.f台",device_num];
//    }
    //封面
    [UIImageView sd_setImageView:self.coveImageView WithURL:dict[@"header_img"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
