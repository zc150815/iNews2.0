//
//  INNewsDetailController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsDetailController.h"

@interface INNewsDetailController ()

@end

@implementation INNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *bar = [[UIView alloc]initWithFrame:CGRectMake(0, PD_StatusBarHeight, self.view.width, PD_NavHeight)];
    bar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bar];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"back-gray"] toSize:CGSizeMake(PD_Fit(bar.height/4), PD_Fit(bar.height/2))] forState:UIControlStateNormal];
    backBtn.adjustsImageWhenHighlighted = NO;
    backBtn.frame = CGRectMake(0, 0, bar.height, bar.height);
    [backBtn addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    
    //标题
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont fontWithName:SFProTextBold size:17];
    titleLab.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    titleLab.text = @"详情";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(bar.width/2-bar.width/4, 0, bar.width/2, bar.height);
    [bar addSubview:titleLab];
    
    //编辑按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.adjustsImageWhenHighlighted = NO;
    editBtn.titleLabel.font = [UIFont fontWithName:SFProTextSemibold size:17];
    [editBtn setTitle:@"Aa" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    editBtn.frame = CGRectMake(bar.width-bar.height, 0, bar.height, bar.height);
//    [editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:editBtn];
    
}
-(void)popCurrentViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
