//
//  DetaTableViewCell.m
//  SDMonitSystem
//
//  Created by tiao on 2018/3/19.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "DetaTableViewCell.h"

#import "YHWorkGroupPhotoContainer.h"

@interface DetaTableViewCell ()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic,strong) YHWorkGroupPhotoContainer *imageV;

//约束
@property (nonatomic,strong)NSLayoutConstraint *cstHeightPicContainer;

@end


@implementation DetaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

-(void) createUI{
    __weak typeof(self) weakSelf = self;
    self.titleLab = [UILabel new];
    self.titleLab.textColor = [UIColor blackColor];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.titleLab];
    
    self.timeLab = [UILabel new];
    self.timeLab.textColor = [UIColor lightGrayColor];
    self.timeLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.timeLab];
    
    self.imageV  =[[YHWorkGroupPhotoContainer alloc]initWithWidth:KScreenW -20];
  //  self.imageV.backgroundColor  =[UIColor redColor];
    [self addSubview:self.imageV];
 
    self.imageV.btnBlock = ^(BOOL isBack) {
        weakSelf.btnBlock(isBack);
    };
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(10);
        make.right.equalTo(weakSelf).offset(-10);
    }];

    [self.timeLab  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab.mas_left);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
    }];
    
    _cstHeightPicContainer = [NSLayoutConstraint constraintWithItem:self.imageV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self addConstraint:_cstHeightPicContainer];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).offset(5);
        make.right.equalTo(weakSelf).offset(-10);
        make.bottom.equalTo(weakSelf).offset(-25);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    self.titleLab.text = dict[@"behavior"];
    self.timeLab.text = dict[@"timestamp"];
    
    NSArray *arr = dict[@"image_url"];
    self.imageV.picOriArray =arr;
    CGFloat picContainerH = [self.imageV setupPicUrlArray:arr];
    _cstHeightPicContainer.constant = picContainerH;
}
+(CGFloat)cellHeightDict:(NSDictionary *)dict{
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width - 20;
    CGFloat viewHeight = 0 ;
    //名称
    NSString *nameStr = dict[@"behavior"];
    CGSize strSize = [nameStr boundingRectWithSize:CGSizeMake(viewWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    viewHeight += strSize.height+10;
    
    //图片
    NSArray *imageArr = dict[@"image_url"];
    if (imageArr.count == 0) {
        viewHeight += 2;
    }else if (imageArr.count < 4){
        viewHeight += (KScreenW - 20)/3;
    }else  if (imageArr.count < 8){
        viewHeight += ((KScreenW - 20)/3)*2;
    }else  if (imageArr.count < 12){
        viewHeight += ((KScreenW - 20)/3)*3;
    }else  if (imageArr.count < 16){
        viewHeight += ((KScreenW - 20)/3)*4;
    }
    
    //时间
    NSString *timeStr = dict[@"timestamp"];
    CGSize timeSize = [timeStr boundingRectWithSize:CGSizeMake(viewWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    
    viewHeight += timeSize.height + 20;
    return viewHeight;
}
- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
