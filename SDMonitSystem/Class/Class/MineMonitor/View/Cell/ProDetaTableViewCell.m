//
//  ProDetaTableViewCell.m
//  SDMontir
//
//  Created by tiao on 2018/1/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "ProDetaTableViewCell.h"

@interface ProDetaTableViewCell ()
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
//事件名字
@property (weak, nonatomic) IBOutlet UILabel *eventNameLab;
//封面图
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
//播放图标
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
//是否第一图标
@property (weak, nonatomic) IBOutlet UIImageView *unOneImageView;

@end

@implementation ProDetaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
//    if (indexPath.row != 0) {
//        self.unOneImageView.image = [UIImage imageNamed:@"vodPlay_normal"];
//    }
    
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    //违规时间
    self.timeLab.text = dict[@"timestamp"];
    
    //事件名称
    self.eventNameLab.text = dict[@"behavior"];
    
    //封面
    [Tool sd_setImageView:self.coverImageView WithURL:dict[@"image_url"]];
}
+(CGFloat)heightForExplain:(NSString *)exqlain{
    UILabel *detailLabel = [[UILabel alloc]init];
    
    detailLabel.numberOfLines = 0;
    CGFloat explainHeight = [exqlain boundingRectWithSize:CGSizeMake(KScreenW/2 - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    return explainHeight  + 45;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
