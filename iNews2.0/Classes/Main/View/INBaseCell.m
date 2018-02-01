//
//  INBaseCell.m
//  iNews2.0
//
//  Created by 123 on 2018/2/1.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INBaseCell.h"

@implementation INBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor getColor:COLOR_BORDER_BASE];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}


@end
