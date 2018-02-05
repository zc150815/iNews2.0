//
//  INDetailToolsView.m
//  iNews2.0
//
//  Created by 123 on 2018/2/2.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INDetailToolsView.h"

@interface INDetailToolsView()<UITextFieldDelegate>

@end
@implementation INDetailToolsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor getColor:@"FBFBFB"];
        
        NSArray *titleArr = @[@"share_button",@"collect_inactive",@"comments"];
        for (NSInteger i=0; i<titleArr.count; i++) {
            UIButton *toolsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            toolsBtn.tag = i+100;
            toolsBtn.adjustsImageWhenHighlighted = NO;
            [toolsBtn setImage:[UIImage imageNamed:titleArr[i]] forState:UIControlStateNormal];
            toolsBtn.frame = CGRectMake(frame.size.width-(i+1)*frame.size.height,0, frame.size.height, frame.size.height);
            [toolsBtn addTarget:self action:@selector(toolsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:toolsBtn];
        }
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(PD_Fit(8), PD_Fit(8), frame.size.width-3*frame.size.height-PD_Fit(8), frame.size.height-2*PD_Fit(8))];
        textField.tag = INDetailToolsViewTypeSearch;
        textField.delegate = self;
        textField.backgroundColor = [UIColor getColor:@"ECECEC"];
        textField.layer.cornerRadius = PD_Fit(10);
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
        paraStyle.firstLineHeadIndent = PD_Fit(8);
        
        NSAttributedString *attributed = [[NSAttributedString alloc]initWithString:@"Say something" attributes:@{NSFontAttributeName:[UIFont fontWithName:SFProTextRegular size:16],NSForegroundColorAttributeName:[UIColor getColor:@"999999"],NSParagraphStyleAttributeName:paraStyle}];
        textField.attributedPlaceholder = attributed;
        [self addSubview:textField];
    }
    return self;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(INDetailToolsView:toolsButtonClickWith:)]) {
        [self.delegate INDetailToolsView:self toolsButtonClickWith:INDetailToolsViewTypeSearch];
    }
    return YES;
}

-(void)toolsButtonClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(INDetailToolsView:toolsButtonClickWith:)]) {
        [self.delegate INDetailToolsView:self toolsButtonClickWith:sender.tag];
    }
}
@end
