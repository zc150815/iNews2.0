//
//  INNewsListNomalCell.m
//  iNews2.0
//
//  Created by 123 on 2018/1/27.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListNomalCell.h"

@interface INNewsListNomalCell()

@property(nonatomic,strong) UIImageView *smallImage;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UILabel *timeLab;

@property(nonatomic,assign) BOOL hasPic;

@property(nonatomic,strong) MASConstraint *titleLabLeading;


@end

@implementation INNewsListNomalCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setupUI];
        
    }
    return self;
    
}

-(void)setupUI{
    
    UIImageView *smallImage = [[UIImageView alloc]init];
    smallImage.contentMode = UIViewContentModeScaleAspectFill;
    smallImage.clipsToBounds = YES;
    smallImage.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:smallImage];
    self.smallImage = smallImage;
    [smallImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
        make.width.mas_equalTo(PD_Fit(112));
        make.height.mas_equalTo(PD_Fit(84));
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont fontWithName:SFProTextSemibold size:PD_Fit(NOMAL_TITLE_FONTSIZE)];
    titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    titleLab.numberOfLines = 3;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
        make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
    }];
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.font = [UIFont fontWithName:SFProTextRegular size:PD_Fit(BASE_TIME_FONTSIZE)];
    [self.contentView addSubview:timeLab];
    self.timeLab = timeLab;
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLab);
        make.bottom.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
    }];
    
}

-(void)setModel:(INNewsListModel *)model{
    _model = model;
    
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"%@|%@",@"CHINA",model.pub_time.length?model.pub_time:model.create_time];
    NSArray *imageArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:model.image_list_detail];
    if (imageArr.count) {
        _hasPic = YES;
        INNewsListModel *model = (INNewsListModel*)imageArr.firstObject;
        [self.smallImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageLowPriority];
    }else{
        _hasPic = NO;
    }
    self.smallImage.hidden = !_hasPic;
    
    [self.titleLabLeading uninstall];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_hasPic) {
            self.titleLabLeading = make.leading.equalTo(self.smallImage.mas_trailing).offset(PD_Fit(10));
        }else{
            self.titleLabLeading = make.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
        }
    }];
}

@end
