//
//  INDetailFooterView.m
//  iNews2.0
//
//  Created by 123 on 2018/2/2.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INDetailFooterView.h"

@implementation INDetailFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    self.backgroundColor = PD_RandomColor;
    
}


-(void)setModel:(INNewsListModel *)model{
    _model = model;
}
@end
