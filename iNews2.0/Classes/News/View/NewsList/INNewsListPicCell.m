//
//  INNewsListPicCell.m
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListPicCell.h"

@interface INNewsListPicCell()
@property (nonatomic,strong) UIView *picView;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *typeBtn;
@end

@implementation INNewsListPicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    UIView *picView = [[UIView alloc]init];
    [self.contentView addSubview:picView];
    self.picView = picView;
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
        make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
        make.height.mas_equalTo((PD_ScreenWidth-3*PD_Fit(BASE_MARGIN))/2);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont fontWithName:SFProTextBold size:PD_Fit(PIC_TITLE_FONTSIZE)];
    titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    titleLab.numberOfLines = 3;
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
        make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
        make.top.equalTo(picView.mas_bottom).offset(PD_Fit(BASE_MARGIN));
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
    [typeBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    typeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    typeBtn.layer.borderWidth = PD_Fit(2);
    typeBtn.layer.cornerRadius = PD_Fit(10);
    typeBtn.contentEdgeInsets = UIEdgeInsetsMake(PD_Fit(BASE_MARGIN), PD_Fit(BASE_MARGIN), PD_Fit(BASE_MARGIN), PD_Fit(BASE_MARGIN));
    [self.contentView addSubview:typeBtn];
    self.typeBtn = typeBtn;
    [typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PD_Fit(20));
        make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN*2));
        make.bottom.equalTo(picView.mas_bottom).offset(PD_Fit(-BASE_MARGIN));
    }];
    
}

-(void)setModel:(INNewsListModel *)model{
    _model = model;
    
    NSArray *imageArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:model.image_list_detail];

    CGFloat baseH = (PD_ScreenWidth-3*PD_Fit(BASE_MARGIN))/2;
    
    [self.picView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (imageArr.count <3) {//双图
        
        for (NSInteger i=0; i<2; i++) {
            UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(baseH+PD_Fit(BASE_MARGIN)), 0, baseH, baseH)];
            picView.contentMode = UIViewContentModeScaleAspectFill;
            picView.clipsToBounds = YES;
            [picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",((INNewsListModel*)imageArr[i]).url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageLowPriority];
            [self.picView addSubview:picView];
        }
        self.typeBtn.hidden = YES;
        
    }else{//三图
        
        for (NSInteger i=0; i<3; i++) {
            UIImageView *picView = [[UIImageView alloc]init];
            CGFloat picX;
            CGFloat picY;
            CGFloat picW;
            CGFloat picH;
            if (i) {
                picH = (baseH-PD_Fit(BASE_MARGIN))/2;
                picW = PD_ScreenWidth-3*PD_Fit(BASE_MARGIN)-baseH*4/3;
                picX = baseH*4/3 + PD_Fit(BASE_MARGIN);
                picY = (i-1)*(picH+PD_Fit(BASE_MARGIN));
            }else{
                picX = 0;
                picY = 0;
                picH = baseH;
                picW = baseH*4/3;
                
            }
            picView.frame = CGRectMake(picX, picY, picW, picH);
            [picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",((INNewsListModel*)imageArr[i]).url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageLowPriority];
            [self.picView addSubview:picView];
        }
        self.typeBtn.hidden = NO;
        [self.typeBtn setTitle:[NSString stringWithFormat:@"%zd photos",imageArr.count] forState:UIControlStateNormal];
        [self.picView bringSubviewToFront:self.typeBtn];

    }

    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"%@|%@",@"CHINA",model.pub_time.length?model.pub_time:model.create_time];
    
    
}
@end
