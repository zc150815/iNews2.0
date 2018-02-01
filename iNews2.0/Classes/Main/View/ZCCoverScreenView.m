//
//  ZCCoverScreenView.m
//  iNews2.0
//
//  Created by 123 on 2018/2/1.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "ZCCoverScreenView.h"
#import "AppDelegate+INAppSetting.h"

@interface ZCCoverScreenView()

@property (nonatomic, strong) UIView *mainView;

@end
@implementation ZCCoverScreenView

//单例创建对象
+(ZCCoverScreenView*)sharedCoverScreenView{
    
    static dispatch_once_t onceToken;
    static ZCCoverScreenView* instanceType;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc]init];
        
    });
    return instanceType;
}
+(void)show{
    [[self sharedCoverScreenView] show];
}
+(void)dismiss{
    [[self sharedCoverScreenView] dismiss];
}
+(void)removeNotInterstedNewsWithSubview:(UIView*)subview{
    [[self sharedCoverScreenView]removeNotInterstedNewsWithSubview:subview];
}






#pragma mark - 实现方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
-(void)show{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    self.frame = window.frame;
    
    [((AppDelegate*)([UIApplication sharedApplication].delegate)) setStatusBarBackgroundColor:[UIColor clearColor]];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        _isShowing = YES;
    }];
}

-(void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
        _isShowing = NO;
        [((AppDelegate*)([UIApplication sharedApplication].delegate)) setStatusBarBackgroundColor:[UIColor whiteColor]];
    }];
}



//移除不感兴趣的新闻列表内容
-(void)removeNotInterstedNewsWithSubview:(UIView*)subview{
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[subview convertRect: subview.bounds toView:window];

    CGFloat subviewBottom = rect.origin.y+rect.size.height;
    CGFloat windowBottom = PD_ScreenHeight-PD_TabBarHeight;
    CGFloat sureViewH = 120;
    
    //主体结构
    UIView *sureView = [[UIView alloc]init];
    sureView.backgroundColor = [UIColor whiteColor];
    sureView.layer.cornerRadius = 10;
    sureView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    //    sureView.layer.shadowColor = [UIColor getColor:COLOR_BASE].CGColor;
    sureView.layer.shadowRadius = 10;
    sureView.layer.shadowOpacity = 1;
    sureView.layer.shadowOffset = CGSizeMake(0, 0);
    [self addSubview:sureView];
    
    
    //上下不同展示方式的图片拉伸设置
    UIImage * topBubble = [UIImage imageNamed:@"ReceiverTextNodeBkg.png"];
    UIImage * bottomBubble = [UIImage imageNamed:@"SenderTextNodeBkg.png"];
    topBubble = [topBubble stretchableImageWithLeftCapWidth:topBubble.size.width/2 topCapHeight:topBubble.size.height/2];
    bottomBubble = [bottomBubble stretchableImageWithLeftCapWidth:bottomBubble.size.width/2 topCapHeight:bottomBubble.size.height/2];
    
    if ((windowBottom - subviewBottom)<sureViewH) {
        //高度不够,在上面展示
        sureView.frame= CGRectMake(PD_Fit(8), subviewBottom-sureViewH-PD_Fit(25), PD_ScreenWidth-2*PD_Fit(8), sureViewH);
    }else{
        //高度足够,在下面显示
        sureView.frame = CGRectMake(PD_Fit(8), subviewBottom, PD_ScreenWidth-2*PD_Fit(8), sureViewH);
    }
    
    
    //分割线
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor getColor:COLOR_BORDER_BASE];
    line.frame = CGRectMake(0, sureView.height*3/5, sureView.width, 0.5);
    [sureView addSubview:line];
    

    //确认按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"Not Interested" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:SFProTextRegular size:20];
    sureBtn.bounds = CGRectMake(0, 0, sureView.width, sureView.height-CGRectGetMaxY(line.frame));
    sureBtn.center = CGPointMake(sureView.width/2, sureView.height-sureBtn.height/2);
    [sureBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sureView addSubview:sureBtn];
    
    
    //提示语
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, sureView.width, CGRectGetMinY(line.frame))];
    titleLab.text = @"Are you sure you are not intersted in \nstories like this?";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor getColor:@"8F8F8F"];
    titleLab.font = [UIFont fontWithName:SFProTextSemibold size:13];
    titleLab.numberOfLines = 0;
    [sureView addSubview:titleLab];
    
}
-(void)sureButtonClick{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(makeSureToRemoveNotInterestedNews)]) {
        [self.delegate makeSureToRemoveNotInterestedNews];
    }
}
@end
