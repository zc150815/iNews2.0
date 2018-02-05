//
//  INDetailHeaderView.m
//  iNews2.0
//
//  Created by 123 on 2018/2/2.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INDetailHeaderView.h"

@interface INDetailHeaderView()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *info;
@property (nonatomic,strong) MASConstraint *headerBottom;

@end

@implementation INDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    titleLab.font = [UIFont fontWithName:SFProTextBold size:21];
    titleLab.numberOfLines = 0;
    [self addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(PD_Fit(8));
        make.trailing.equalTo(self).offset(-PD_Fit(8));
//        make.bottom.equalTo(self).offset(-PD_Fit(8));

    }];
    
    UIButton *info = [UIButton buttonWithType:UIButtonTypeCustom];
    info.titleLabel.numberOfLines = 0;
    info.titleLabel.font = [UIFont fontWithName:SFProTextSemibold size:12];
    [info setTitleColor:[UIColor getColor:@"999999"] forState:UIControlStateNormal];
    info.titleEdgeInsets = UIEdgeInsetsMake(0, PD_Fit(8), 0, PD_Fit(-8));
    [self addSubview:info];
    self.info = info;
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(PD_Fit(8));
        make.top.equalTo(titleLab.mas_bottom).offset(PD_Fit(15));
//        make.bottom.equalTo(self).offset(-PD_Fit(8));
    }];
    
}


-(void)setModel:(INNewsListModel *)model{
    _model = model;
    
    _titleLab.text = model.title;
    
    [_headerBottom uninstall];
    if (![model.title containsString:@"Related Stories"]&&![model.title containsString:@"Latest Comments"]) {
        
        UIImage *infoImg = [UIImage scaleFromImage:[UIImage imageNamed:@"temp1"] toSize:CGSizeMake(PD_Fit(32), PD_Fit(32))];
        [_info setImage:[infoImg drawCircleImageWithImage:infoImg WithCornerRadius:infoImg.size.height] forState:UIControlStateNormal];
        [_info setTitle:@"Ding Xiaoxiao | China Plus\n22:00, December 18, 2017" forState:UIControlStateNormal];
        [_info mas_makeConstraints:^(MASConstraintMaker *make) {
            _headerBottom = make.bottom.equalTo(self).offset(-PD_Fit(15));;
        }];
    }else{
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            _headerBottom = make.bottom.equalTo(self).offset(-PD_Fit(15));;
        }];
    }
}
@end
