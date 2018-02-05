
//
//  INNewsChannelCell.m
//  iNews2.0
//
//  Created by 123 on 2018/1/28.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsChannelCell.h"
#import "INNewsListModel.h"

@interface INNewsChannelCell()

@property (nonatomic,strong) UILabel *channelLab;
@property (nonatomic,strong) UIButton *deleBtn;
@end

@implementation INNewsChannelCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

//        UIButton *channelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        channelBtn.layer.borderColor = [UIColor getColor:COLOR_BORDER_BASE].CGColor;
//        channelBtn.layer.borderWidth = 0.5;
//        channelBtn.layer.cornerRadius = 5;
//        channelBtn.titleLabel.font = [UIFont fontWithName:SFProTextBold size:13];
//        [channelBtn setBackgroundColor:[UIColor whiteColor]];
//        channelBtn.frame = CGRectMake(PD_Fit(10), PD_Fit(10), frame.size.width-PD_Fit(10)*2, frame.size.height-PD_Fit(10)*2);
//        self.channelBtn = channelBtn;
//        [self addSubview:channelBtn];
        
        UILabel *channelLab = [[UILabel alloc]initWithFrame:CGRectMake(PD_Fit(10), PD_Fit(10), frame.size.width-PD_Fit(10)*2, frame.size.height-PD_Fit(10)*2)];
        channelLab.layer.borderColor = [UIColor getColor:COLOR_BORDER_BASE].CGColor;
        channelLab.layer.borderWidth = 0.5;
        channelLab.layer.cornerRadius = 5;
        channelLab.textAlignment = NSTextAlignmentCenter;
        channelLab.font = [UIFont fontWithName:SFProTextBold size:13];
        channelLab.textColor = [UIColor whiteColor];
        self.channelLab = channelLab;
        [self addSubview:channelLab];
        
        
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"edit_remove"];
        [deleBtn setImage:image forState:UIControlStateNormal];
        deleBtn.center = CGPointMake(CGRectGetMaxX(channelLab.frame), CGRectGetMinY(channelLab.frame));
        deleBtn.bounds = CGRectMake(0, 0, deleBtn.currentImage.size.width, deleBtn.currentImage.size.height);
        [deleBtn addTarget:self action:@selector(removeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.deleBtn = deleBtn;
        [self addSubview:deleBtn];
  

    }
    return self;
}

-(void)removeButtonClick{
    if ([self.delegate respondsToSelector:@selector(removeChannelWithINNewsChannelCell:)]) {
        [self.delegate removeChannelWithINNewsChannelCell:self];
    }
}


-(void)setModel:(INNewsListModel *)model{
    _model = model;
    
    _channelLab.text = model.channel;
    _channelLab.textColor = model.canEdit?[UIColor getColor:COLOR_BROWN_DEEP]:[UIColor getColor:COLOR_BROWN_LIGHT];
    
    _deleBtn.hidden = !(model.canEdit&&model.isEditing);
    

    
}
@end
