//
//  LaunchScreenController.m
//  iNews2.0
//
//  Created by 123 on 2018/2/2.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "LaunchScreenController.h"
#import "INTabBarController.h"
#import "AppDelegate+INAppSetting.h"

@interface LaunchScreenController ()

@property (nonatomic,strong) UIImageView *launchView;
@property (nonatomic,strong) UIButton *passBtn;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic, strong) NSTimer *countTimer;

@end

@implementation LaunchScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _count = 2;
    
    [self setupUI];
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    CGFloat width = self.view.width;
    CGFloat launchH = width * 1050 / 750;

    UIImageView *launchView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, launchH)];
    launchView.image = [UIImage imageNamed:[NSString stringWithFormat:@"LaunchScreen_%d",arc4random()%11]];
    self.launchView = launchView;
    [self.view addSubview:launchView];
    
    
    CGFloat logoH = width * 284 / 750;
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.height-logoH, width, logoH)];
    logoView.image = [UIImage imageNamed:[NSString stringWithFormat:@"logo"]];
    [self.view addSubview:logoView];

    
    UIButton *passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passBtn.titleLabel.font = [UIFont fontWithName:SFProTextBold size:15];
    [passBtn setTitle:[NSString stringWithFormat:@"跳过(%zd)",_count] forState:UIControlStateNormal];
    [passBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [passBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [passBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [passBtn addTarget:self action:@selector(passButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passBtn];
    self.passBtn = passBtn;
    [passBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PD_Fit(10));
        make.trailing.equalTo(self.view).offset(PD_Fit(-10));
    }];
}

-(void)passButtonClick{
    
    [_countTimer invalidate];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[INTabBarController alloc]init];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [((AppDelegate*)([UIApplication sharedApplication].delegate)) setStatusBarBackgroundColor:[UIColor whiteColor]];
    [((AppDelegate*)([UIApplication sharedApplication].delegate)) checkNewVersionApp];
    
}
-(void)timerFired:(NSTimer *)timer{
    
    if (_count !=0) {
        _count -=1;
        [_passBtn setTitle:[NSString stringWithFormat:@"跳过(%zd)",_count] forState:UIControlStateNormal];
    }else{
        [timer invalidate];
        [_passBtn setTitle:@"跳过(0)" forState:UIControlStateNormal];
        [self passButtonClick];
    }
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    _launchView.image = [UIImage imageNamed:[NSString stringWithFormat:@"LaunchScreen_%d",arc4random()%11]];
//
//}
@end
