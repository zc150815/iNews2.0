//
//  INBaseController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/31.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INBaseController.h"

@interface INBaseController ()

@end

@implementation INBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, PD_StatusBarHeight, self.view.width, PD_NavHeight)];
    bar.backgroundColor = [UIColor whiteColor];
    self.navBar = bar;
    [self.view addSubview:bar];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"back-gray"] toSize:CGSizeMake(PD_Fit(bar.height/4), PD_Fit(bar.height/2))] forState:UIControlStateNormal];
    backBtn.adjustsImageWhenHighlighted = NO;
    backBtn.frame = CGRectMake(0, 0, bar.height, bar.height);
    [backBtn addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    self.backBtn = backBtn;
    
    //标题
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont fontWithName:SFProTextBold size:17];
    titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    titleLab.text = self.title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(bar.width/2-bar.width/4, 0, bar.width/2, bar.height);
    [bar addSubview:titleLab];
    
}
-(void)popCurrentViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
