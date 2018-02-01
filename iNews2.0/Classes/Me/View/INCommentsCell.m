//
//  INCommentsCell.m
//  iNews2.0
//
//  Created by 123 on 2018/2/1.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INCommentsCell.h"

@interface INCommentsCell()

@property (nonatomic,strong) UIImageView *userImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *commentLab;

@end

@implementation INCommentsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UIImageView *userImg = [[UIImageView alloc]init];
    [self.contentView addSubview:userImg];
    self.userImg = userImg;
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(PD_Fit(BASE_MARGIN));
        make.width.height.mas_equalTo(PD_Fit(32));
    }];
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.font = [UIFont fontWithName:SFProTextBold size:COMMENT_COMMENT_FONTSIZE];
    nameLab.textColor = [UIColor getColor:@"636363"];
    [self.contentView addSubview:nameLab];
    self.nameLab = nameLab;
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userImg);
        make.leading.equalTo(userImg.mas_trailing).offset(PD_Fit(BASE_MARGIN));
    }];
    
    UILabel *commentLab = [[UILabel alloc]init];
    commentLab.font = [UIFont fontWithName:SFProTextRegular size:COMMENT_COMMENT_FONTSIZE];
    commentLab.textColor = [UIColor getColor:@"4A4A4A"];
    commentLab.numberOfLines = 0;
    [self.contentView addSubview:commentLab];
    self.commentLab = commentLab;
    [commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(PD_Fit(BASE_MARGIN));
        make.leading.equalTo(nameLab);
        make.trailing.equalTo(self.contentView).offset(PD_Fit(-BASE_MARGIN));
    }];
    
}

-(void)setModel:(INNewsListModel *)model{
    _model = model;

    UIImage *img = [UIImage imageNamed:@"temp1"];
    _userImg.image = [img drawCircleImageWithImage:img WithCornerRadius:PD_Fit(32)];
    
    _nameLab.text = @"Lucifer";
    _commentLab.text = model.comment;
}
@end
