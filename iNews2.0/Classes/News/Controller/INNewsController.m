//
//  INNewsController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsController.h"
#import "ZCSliderView.h"
#import "INNewsListController.h"
#import "INNewsDetailController.h"
#import "INNewsChannelController.h"

@interface INNewsController ()<ZCSliderViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *sliderArr;
@property (nonatomic,strong) ZCSliderView *sliderView;
@property (nonatomic,strong) UIScrollView *mainView;

@end

@implementation INNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideSliderView) name:@"HIDESLIDERVIEWNOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showSliderView) name:@"SHOWSLIDERVIEWNOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshSortingData) name:UITABLEVIEW_RELOAD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapAgainScrollToTop) name:@"TAPAGAIN_TOTOP_NOTIFICATION" object:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadSortingData];
    });

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - setupUI
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    ZCSliderView *sliderView = [[ZCSliderView alloc]initWithFrame:CGRectMake(0, PD_StatusBarHeight, self.view.width, PD_NavHeight)];
    sliderView.ZC_BorderWidth = 0;
    sliderView.ZC_Font = [UIFont fontWithName:SFProTextBold size:PD_Fit(18)];
    sliderView.ZC_SliderColor = [UIColor getColor:COLOR_BASE];
    sliderView.ZC_TextColor_Nomal = [UIColor getColor:@"919191"];
    sliderView.ZC_TextColor_Selected = [UIColor getColor:COLOR_BASE];
    sliderView.delegate = self;
    self.sliderView = sliderView;
    [self.view addSubview:sliderView];
    
    UIScrollView *mainView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, PD_StatusBarHeight, self.view.width, self.view.height-PD_StatusBarHeight)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.pagingEnabled = YES;
    mainView.delegate = self;
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.mainView = mainView;
    [self.view addSubview:mainView];
    
    [self.view bringSubviewToFront:sliderView];
}
#pragma mark - loadData
-(void)loadSortingData{
    
    self.sliderArr = @[@"TOP NEWS",@"CHINA",@"WORLD",@"BUSINESS",@"OPINIONS",@"TRAVEL",@"PHOTOS",@"Services",@"Culture",@"Sports",@"Features",@"Tech",@"Lifestyle",@"LOL",@"Health",@"Entertainment",@"Fashion",@"Auto"];
    
    self.sliderView.sliderArr = self.sliderArr;

    self.mainView.contentSize = CGSizeMake(self.view.width*self.sliderArr.count, 0);
    [self addChildViewController];//为当前controller添加子控制器

//    [self ZCSliderView:self.sliderView didSelectItemAtIndex:0];
    self.sliderView.index = 0;

    
}


#pragma mark - AddChildViewController
-(void)addChildViewController{
    
    for (int i = 0; i<self.sliderArr.count; i++) {
        INNewsListController *vc  = [[INNewsListController alloc] init];
        vc.title  =  self.sliderArr[i];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:vc];
    }
}

#pragma mark - ZCSliderViewDelegateMethod
-(void)ZCSliderView:(ZCSliderView *)sliderView didSelectItemAtIndex:(NSInteger)index{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCSliderViewClickNotification" object:[NSString stringWithFormat:@"%@",self.sliderArr[index]]];
    
    INNewsListController *listVC  =  self.childViewControllers[index];
    if (!listVC.view.superview) {
        listVC.tableView.frame = CGRectMake(index * self.mainView.width, 0, self.mainView.width, self.mainView.height);
        [self.mainView addSubview:listVC.view];
        [listVC loadData];
    }else{
        [listVC loadData];
    }
    [[SDImageCache sharedImageCache] clearMemory];
    self.mainView.contentOffset = CGPointMake(index * self.mainView.width, 0);
    
}
-(void)editSliderView{
    
    INNewsChannelController *channelVC = [[INNewsChannelController alloc]init];
    channelVC.title = @"Channels";
    [self.navigationController pushViewController:channelVC animated:YES];
}
#pragma mark - UIScrollViewDelegateMethod
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.sliderView.index = index;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self showSliderView];
}
#pragma mark - 懒加载
-(NSArray *)sliderArr{
    if (!_sliderArr) {
        _sliderArr = [NSArray new];
    }
    return _sliderArr;
}

#pragma mark - 通知事件
-(void)hideSliderView{
    [UIView animateWithDuration:0.5 animations:^{
        self.sliderView.frame = CGRectMake(0, -PD_NavHeight, self.view.width, PD_NavHeight);
    }];
}
-(void)showSliderView{
    [UIView animateWithDuration:0.5 animations:^{
        self.sliderView.frame = CGRectMake(0, PD_StatusBarHeight, self.view.width, PD_NavHeight);
    }];
}
-(void)refreshSortingData{
    self.sliderView.sliderArr = self.sliderArr;
    
    NSInteger index = self.mainView.contentOffset.x / self.mainView.width;

    self.sliderView.index = index;
}

-(void)tapAgainScrollToTop{
    
    NSInteger index = self.mainView.contentOffset.x / self.mainView.width;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    INNewsListController *listVC = self.childViewControllers[index];
    [listVC.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
@end
