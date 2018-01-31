//
//  INNewsListSpecialCell.m
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListSpecialCell.h"


@interface INNewsListSpecialCell()<SDCycleScrollViewDelegate>

@property (nonatomic,strong) SDCycleScrollView *bannerView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;

@end

@implementation INNewsListSpecialCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        

        CGFloat width = PD_ScreenWidth;
        CGFloat height = width *3/4;
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, width, height) delegate:self placeholderImage:[UIImage scaleFromImage:[UIImage imageNamed:@"placeholder"] toSize:CGSizeMake(width, height)]];
        bannerView.showPageControl = YES;
        bannerView.clipsToBounds = YES;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        bannerView.clipsToBounds = YES;
        [self.contentView addSubview:bannerView];
        self.bannerView = bannerView;
        
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont fontWithName:SFProTextBold size:PD_Fit(SPECIAL_TITLE_FONTSIZE)];
        titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
        titleLab.numberOfLines = 3;
        [self.contentView addSubview:titleLab];
        self.titleLab = titleLab;
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
            make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
            make.top.equalTo(bannerView.mas_bottom).offset(PD_Fit(BASE_MARGIN));
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
        [typeBtn setTitle:@"Special" forState:UIControlStateNormal];
        typeBtn.titleLabel.font = [UIFont fontWithName:CircularAirProBold size:PD_Fit(12)];
        [typeBtn setBackgroundColor:[UIColor getColor:COLOR_BASE]];
        [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        typeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        typeBtn.layer.borderWidth = PD_Fit(2);
        typeBtn.layer.cornerRadius = PD_Fit(10);
        typeBtn.contentEdgeInsets = UIEdgeInsetsMake(PD_Fit(5.0/2), PD_Fit(BASE_MARGIN), PD_Fit(5.0/2), PD_Fit(BASE_MARGIN));
        [self.contentView addSubview:typeBtn];
        [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(PD_Fit(20));
            make.leading.equalTo(self.contentView).offset(PD_Fit(10));
            make.bottom.equalTo(bannerView.mas_bottom).offset(PD_Fit(-10));
        }];
    }
    return self;
}
-(void)setModel:(INNewsListModel *)model{
    _model = model;
    
    NSArray *imageArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:model.image_list_detail];
    NSMutableArray *imageUrl = [NSMutableArray arrayWithCapacity:imageArr.count];
    for (INNewsListModel *model in imageArr) {
        [imageUrl addObject:model.url];
    }
    self.bannerView.imageURLStringsGroup = imageUrl;
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"%@|%@",@"CHINA",model.pub_time.length?model.pub_time:model.create_time];

}
@end
