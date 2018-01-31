//
//  INNewsListLiveCell.m
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListLiveCell.h"

@interface INNewsListLiveCell()
@property (nonatomic,strong) UIImageView *liveView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *typeBtn;

@end
@implementation INNewsListLiveCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *liveView = [[UIImageView alloc]init];
        liveView.contentMode = UIViewContentModeScaleAspectFill;
        liveView.clipsToBounds = YES;
        liveView.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:liveView];
        self.liveView = liveView;
        [liveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
            make.leading.trailing.equalTo(self.contentView);
            make.height.mas_equalTo(PD_ScreenWidth*9/16);
        }];
        
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont fontWithName:SFProTextBold size:PD_Fit(LIVE_TITLE_FONTSIZE)];
        titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
        titleLab.numberOfLines = 3;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
            make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
            make.top.equalTo(liveView.mas_bottom).offset(PD_Fit(BASE_MARGIN));
        }];
        
        UILabel *timeLab = [[UILabel alloc]init];
        timeLab.font = [UIFont fontWithName:SFProTextRegular size:PD_Fit(BASE_TIME_FONTSIZE)];
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
            make.bottom.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
        }];
        
        UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.titleLabel.font = [UIFont fontWithName:CircularAirProBold size:PD_Fit(12)];
        [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        typeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        typeBtn.layer.borderWidth = PD_Fit(2);
        typeBtn.layer.cornerRadius = PD_Fit(10);
        typeBtn.contentEdgeInsets = UIEdgeInsetsMake(PD_Fit(BASE_MARGIN), PD_Fit(BASE_MARGIN), PD_Fit(BASE_MARGIN), PD_Fit(BASE_MARGIN));
        [self.contentView addSubview:typeBtn];
        self.typeBtn = typeBtn;
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PD_Fit(20));
            make.leading.equalTo(self.contentView).offset(PD_Fit(10));
            make.bottom.equalTo(liveView.mas_bottom).offset(PD_Fit(-10));
        }];
    }
    return self;
}
-(void)setModel:(INNewsListModel *)model{
    _model = model;
    
    NSArray *imageArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:model.image_list_detail];

    [_liveView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",((INNewsListModel*)imageArr.firstObject).url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageDelayPlaceholder];
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"%@|%@",@"CHINA",model.pub_time.length?model.pub_time:model.create_time];
    
    NSInteger ListType = model.contenttype.integerValue;
    if (ListType==INNewsListTypeVideo) {
        [_typeBtn setTitle:@"▶︎00:38" forState:UIControlStateNormal];
        [_typeBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    }else{
        [_typeBtn setTitle:model.contenttype.integerValue==INNewsListTypeLive?@"▶︎ Live":@"▶︎ Review" forState:UIControlStateNormal];
        [_typeBtn setBackgroundColor:[UIColor getColor:@"E65622"]];
    }

    
}
@end
