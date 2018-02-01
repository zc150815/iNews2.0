//
//  INMyCommentsController.m
//  iNews2.0
//
//  Created by 123 on 2018/2/1.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INMyCommentsController.h"
#import "INCommentsCell.h"

@interface INMyCommentsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *dataLayoutArr;

@end

@implementation INMyCommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    
    //主视图
    UITableView *mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mainView.bounces = NO;
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor getColor:COLOR_BACKGROUND_BASE];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [mainView registerClass:[INCommentsCell class] forCellReuseIdentifier:@"INCommentsCellID"];
    self.mainView = mainView;
    [self.view addSubview:mainView];
    
    [self.view bringSubviewToFront:self.navBar];
    mainView.contentInset = UIEdgeInsetsMake(self.navBar.height, 0, 0, 0);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    INCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INCommentsCellID" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataLayoutArr[indexPath.row] floatValue];
}

#pragma mark - LodaData
-(void)loadData{
    
    NSArray *array =@[
                      //special(over)
                      @{
                          @"id":@"90545",
                          @"title":@"Alibaba, US grocer Kroger had early business development talks: source",
                          @"comment_num":@"0",
                          @"pub_time":@"2 hours ago",
                          @"create_time":@"2018-01-27 13:22:36",
                          @"image_list":@"1",
                          @"to_top":@"0",
                          @"contenttype":@"0",
                          @"return_time":@"2018-01-27 13:22:35",
                          @"comment":@"Technological innovation in products and services🤝among three different companies in Guangzhou is said to be improved people's lives.👏"
                          },
                      //小图(over)
                      @{
                          @"id":@"90534",
                          @"title":@"Preview of Japanese foreign minister's China visit",
                          @"comment_num":@"0",
                          @"pub_time":@"2 hours ago",
                          @"create_time":@"2018-01-27 12:57:16",
                          @"image_list":@"2",
                          @"to_top":@"0",
                          @"contenttype":@"100",
                          @"return_time":@"2018-01-27 12:55:29",
                          @"comment":@"😉GRG Banking in Guangzhou is also trying to make technology work for people."
                          },
                      //无图(over)
                      @{
                          @"id":@"90531",
                          @"title":@"At least 13 killed after bus falls into river in western India",
                          @"comment_num":@"0",
                          @"pub_time":@"3 hours ago",
                          @"create_time":@"2018-01-27 12:40:48",
                          @"image_list":@"0",
                          @"to_top":@"0",
                          @"contenttype":@"100",
                          @"image_list_detail":@[],
                          @"return_time":@"2018-01-27 12:40:12",
                          @"comment":@"I really wanna go somewhere I can try skydiving without accompany."
                          },
                      //双图
                      @{
                          @"id":@"90441",
                          @"title":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 09:29:55",
                          @"image_list":@"2",
                          @"to_top":@"0",
                          @"contenttype":@"1",
                          @"return_time":@"2018-01-27 08:50:54",
                          @"comment":@"👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏👏"
                          },
                      //三图
                      @{
                          @"id":@"90197",
                          @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 11:22:55",
                          @"image_list":@"7",
                          @"to_top":@"0",
                          @"contenttype":@"1",
                          @"return_time":@"2018-01-27 08:50:54",
                          @"comment":@"Entire USA Gymnastics board to resign amid sexual abuse scandal"
                          },
                      //直播
                      @{
                          @"id":@"90503",
                          @"title":@"Trump reiterates 'America First' but softening tone at Davos forum",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 11:43:37",
                          @"image_list":@"2",
                          @"to_top":@"0",
                          @"contenttype":@"2",
                          @"return_time":@"2018-01-27 11:43:36",
                          @"comment":@"Women's daredevil bikers brigade celebrates India's Republic Day"
                          },
                      //回放
                      @{
                          @"id":@"90430",
                          @"title":@"Internet giant acquires slice of Hollywood studio",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 09:01:23",
                          @"image_list":@"1",
                          @"to_top":@"0",
                          @"contenttype":@"3",
                          @"return_time":@"2018-01-27 09:01:22",
                          @"comment":@"Entire USA Gymnastics board to resign amid sexual abuse scandal"
                          },
                      //视频
                      @{
                          @"id":@"90429",
                          @"title":@"China's industrial firms see faster profit growth in 2017",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 09:00:29",
                          @"image_list":@"2",
                          @"to_top":@"0",
                          @"contenttype":@"4",
                          @"return_time":@"2018-01-27 09:00:29",
                          @"comment":@"Entire USA Gymnastics board to resign amid sexual abuse scandal"
                          },
                      //special
                      @{
                          @"id":@"90428",
                          @"title":@"Xi's vision of shared future reverberates in Davos",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 08:59:38",
                          @"image_list":@"1",
                          @"to_top":@"0",
                          @"contenttype":@"0",
                          @"return_time":@"2018-01-27 08:59:38",
                          @"comment":@"Trump reiterates 'America First' but softening tone at Davos forum"
                          },
                      @{
                          @"id":@"90462",
                          @"title":@"Video: Women's daredevil bikers brigade celebrates India's Republic Day",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 10:17:03",
                          @"image_list":@"1",
                          @"to_top":@"0",
                          @"contenttype":@"100",
                          @"return_time":@"2018-01-27 10:14:14",
                          @"comment":@"Fairy-tale snow scenery of West Lake in Hangzhou"
                          },
                      //三图
                      @{
                          @"id":@"90197",
                          @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 11:22:55",
                          @"image_list":@"7",
                          @"to_top":@"0",
                          @"contenttype":@"1",
                          @"return_time":@"2018-01-27 08:50:54",
                          @"comment":@"Fairy-tale snow scenery of West Lake in Hangzhou"
                          },
                      //无图
                      @{
                          @"id":@"90430",
                          @"title":@"Internet giant acquires slice of Hollywood studio",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 09:01:23",
                          @"image_list":@"0",
                          @"to_top":@"0",
                          @"contenttype":@"100",
                          @"return_time":@"2018-01-27 09:01:22",
                          @"comment":@"At least 13 killed after bus falls into river in western India"
                          },
                      //双图
                      @{
                          @"id":@"90441",
                          @"title":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                          @"comment_num":@"0",
                          @"pub_time":@"",
                          @"create_time":@"2018-01-27 09:29:55",
                          @"image_list":@"2",
                          @"to_top":@"0",
                          @"contenttype":@"1",
                          @"return_time":@"2018-01-27 09:29:53",
                          @"comment":@"China's industrial firms see faster profit growth in 2017"
                          },
                      ];
    
    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    [self.dataArr addObjectsFromArray:arrayM];
    [self calculateCellHeightWithModelArray:arrayM];
    PD_NSLog(@"通知数据...........................");
    [self.mainView reloadData];
    [self.mainView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
#pragma mark 计算cell高度
-(void)calculateCellHeightWithModelArray:(NSArray*)modelArr{
    
    for (INNewsListModel *model in modelArr) {
        NSString *cellHeight;
        CGFloat titleHeight;
        CGFloat imgViewHeight;
        
        titleHeight = [[INPublicTools sharedPublicTools]calculateLableHeightWithText:model.comment Font:[UIFont fontWithName:SFProTextBold size:COMMENT_COMMENT_FONTSIZE] width:(self.view.width-3*PD_Fit(BASE_MARGIN)-PD_Fit(32)) limitRowCount:0];
        
        cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(BASE_MARGIN)+PD_Fit(COMMENT_COMMENT_FONTSIZE)+PD_Fit(BASE_MARGIN)+titleHeight+PD_Fit(BASE_MARGIN)+PD_Fit(10)];
//        cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(80)];
        [self.dataLayoutArr addObject:cellHeight];
    }
}


#pragma mark - lazy
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)dataLayoutArr{
    if (!_dataLayoutArr) {
        _dataLayoutArr = [NSMutableArray array];
    }
    return _dataLayoutArr;
}
@end
