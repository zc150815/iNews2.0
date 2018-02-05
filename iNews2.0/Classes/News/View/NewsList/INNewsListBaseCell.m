//
//  INNewsListBaseCell.m
//  iNews2.0
//
//  Created by 123 on 2018/1/25.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListBaseCell.h"

@interface INNewsListBaseCell()

@property (nonatomic,strong) UIButton *deleBtn;
@end
@implementation INNewsListBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         
        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleBtn setImage:[UIImage imageNamed:@"cell_close"] forState:UIControlStateNormal];
        deleBtn.adjustsImageWhenHighlighted = NO;
        [deleBtn addTarget:self action:@selector(closeCell) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleBtn];
        self.deleBtn = deleBtn;
        [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(self.contentView);
            make.width.height.mas_equalTo(PD_Fit(35));
        }];
        
    }
    return self;
}

-(void)closeCell{
    
    if ([self.delegate respondsToSelector:@selector(cellCloseWithCellWithContentCell:)]) {
        [self.delegate cellCloseWithCellWithContentCell:self];
    }
}
-(void)setHiddenDeleBtn:(BOOL)hiddenDeleBtn{
    _hiddenDeleBtn = hiddenDeleBtn;
    
    _deleBtn.hidden = hiddenDeleBtn;
}
@end
