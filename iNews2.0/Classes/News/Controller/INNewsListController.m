//
//  INNewsListController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsListController.h"
#import "INNewsListModel.h"
#import "INNewsListBaseCell.h"
#import "INNewsListNomalCell.h"
#import "INNewsListSpecialCell.h"
#import "INNewsListPicCell.h"
#import "INNewsListLiveCell.h"
#import "INNewsListReplayCell.h"
#import "INNewsListVideoCell.h"
#import "INNewsDetailController.h"
#import "INSearchController.h"

@interface INNewsListController ()<INNewsListBaseCellDelegate,UISearchBarDelegate,UITableViewNoDataSource>

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *newsLayoutArr;

@property (nonatomic,assign) CGFloat beginContentOffsetY;

@end

@implementation INNewsListController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[INNewsListNomalCell class] forCellReuseIdentifier:@"INNewsListNomalCellID"];
    [self.tableView registerClass:[INNewsListSpecialCell class] forCellReuseIdentifier:@"INNewsListSpecialCellID"];
    [self.tableView registerClass:[INNewsListPicCell class] forCellReuseIdentifier:@"INNewsListPicCellID"];
    [self.tableView registerClass:[INNewsListLiveCell class] forCellReuseIdentifier:@"INNewsListLiveCellID"];
    self.tableView.errorDataSource = self;
    
    
    //搜索框
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    headerView.backgroundColor = [UIColor whiteColor];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    searchBar.placeholder = @"Search People'a Daily";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.translucent = YES;
    [headerView addSubview:searchBar];
    self.tableView.tableHeaderView = headerView;
    
    
    
    
//    MJRefreshNormalHeader *refreshView = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    MJRefreshNormalHeader *refreshView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (self.tableView.contentOffset.y >300) {
//            [self refreshData];
//        }else{
//
//        }
//
//    }];
//
//    refreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    refreshView.lastUpdatedTimeLabel.hidden = YES;
//    refreshView.state = MJRefreshStateIdle;
//    self.tableView.mj_header = refreshView;
    
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INNewsListModel *model =self.dataArr[indexPath.row];
    NSInteger listType = model.contenttype.integerValue;

    if (listType == INNewsListTypeSpecial) {//专题新闻
        
        INNewsListSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListSpecialCellID" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }else if (listType == INNewsListTypeNomal){//小图|无图
        INNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListNomalCellID" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }else if (listType == INNewsListTypePic){//双图|多图
        INNewsListPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListPicCellID" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }else if (listType == INNewsListTypeLive || listType == INNewsListTypeReplay||listType == INNewsListTypeVideo){//直播|回放|视频
        INNewsListLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListLiveCellID" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.navigationController pushViewController:[[INNewsDetailController alloc]init] animated:YES];
    //test
    [self.dataArr removeAllObjects];
    [self.tableView tableViewLoadNoData];


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = [self.newsLayoutArr[indexPath.row] floatValue];
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    if (self.dataArr.count) {
        [self refreshData];
    }
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.dataArr.count && indexPath.row == self.dataArr.count-2) {
//        [self refreshData];
//    }
//}
//-(void)tableView:(UITableView *)tableView reloadDataWithContentType:(NSInteger)type{
//    
//    [self refreshData];
//}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.beginContentOffsetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat difference = scrollView.contentOffset.y - self.beginContentOffsetY;
//    PD_NSLog(@"contentOffsetY==%f",scrollView.contentOffset.y);
    PD_NSLog(@"difference==%f",difference);

    if (difference >= PD_NavHeight*2) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HIDESLIDERVIEWNOTIFICATION" object:nil];
    }else if (difference <= -PD_NavHeight){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SHOWSLIDERVIEWNOTIFICATION" object:nil];
    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{

    if (scrollView.contentOffset.y <= -PD_NavHeight*2) {
        self.tableView.contentInset = UIEdgeInsetsMake(PD_NavHeight, 0, 0, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [self.navigationController pushViewController:[[INSearchController alloc]init] animated:YES];

    return NO;
}
#pragma mark - INNewsListBaseCellDelegate
-(void)cellCloseWithCellWithContentCell:(INNewsListBaseCell *)contentCell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:contentCell];
    [[INPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"第%ld行删除",(long)indexPath.row] duration:3];
}

#pragma mark - lodaData
-(void)refreshData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });
    
}
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"228004",
                                      @"title":@"Alibaba, US grocer Kroger had early business development talks: source",
                                      @"desc":@"Alibaba, US grocer Kroger had early business development talks: source",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/2713203791q3.png",
                                      @"news_id":@"90545",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227516",
                                      @"title":@"Xi's vision of shared future reverberates in Davos",
                                      @"desc":@"Xi's vision of shared future reverberates in Davos",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20219099/decc717b-1e3f-4c9f-aede-b7687662e372.jpg",
                                      @"news_id":@"90428",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227662",
                                      @"title":@"Video: Women's daredevil bikers brigade celebrates India's Republic Day",
                                      @"desc":@"Video: Women's daredevil bikers brigade celebrates India's Republic Day",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/27101655xuqb.jpeg",
                                      @"news_id":@"90462",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 13:22:35"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227977",
                                      @"title":@"Preview of Japanese foreign minister's China visit",
                                      @"desc":@"Preview of Japanese foreign minister's China visit",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20218984/gctln3yvw0l.jpg",
                                      @"news_id":@"90534",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227978",
                                      @"title":@"Preview of Japanese foreign minister's China visit",
                                      @"desc":@"Preview of Japanese foreign minister's China visit",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20218984/1ixuyxjauef.jpg",
                                      @"news_id":@"90534",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 12:55:29"
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
                          @"return_time":@"2018-01-27 12:40:12"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227578",
                                      @"title":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"desc":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/270922293tb4.jpeg",
                                      @"news_id":@"90441",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227579",
                                      @"title":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"desc":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/2709290754m5.jpg",
                                      @"news_id":@"90441",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 09:29:53"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227756",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/kicssiew131.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227757",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/14dlxekmix2.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227758",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/tu3wg4celrw.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227759",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/lxzclhvfzdm.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227760",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/qsqxmdygs5o.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227761",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/4ugzonff3tk.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227762",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/urgifd0p13z.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 08:50:54"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227809",
                                      @"title":@"Trump reiterates 'America First' but softening tone at Davos forum",
                                      @"desc":@"Trump reiterates 'America First' but softening tone at Davos forum",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/15481/585ef54c-0f6d-458e-8aef-036a0aa7a6aa.jpg",
                                      @"news_id":@"90503",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 11:43:36"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227519",
                                      @"title":@"Internet giant acquires slice of Hollywood studio",
                                      @"desc":@"Internet giant acquires slice of Hollywood studio",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20218889/5a6bbc68a3106e7d2d707f70.jpg",
                                      @"news_id":@"90430",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 09:01:22"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227517",
                                      @"title":@"China's industrial firms see faster profit growth in 2017",
                                      @"desc":@"China's industrial firms see faster profit growth in 2017",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/270900126c62.jpg",
                                      @"news_id":@"90429",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227518",
                                      @"title":@"China's industrial firms see faster profit growth in 2017",
                                      @"desc":@"China's industrial firms see faster profit growth in 2017",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/270900127kkh.jpg",
                                      @"news_id":@"90429",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 09:00:29"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227516",
                                      @"title":@"Xi's vision of shared future reverberates in Davos",
                                      @"desc":@"Xi's vision of shared future reverberates in Davos",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20219099/decc717b-1e3f-4c9f-aede-b7687662e372.jpg",
                                      @"news_id":@"90428",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227516",
                                      @"title":@"Xi's vision of shared future reverberates in Davos",
                                      @"desc":@"Xi's vision of shared future reverberates in Davos",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20219099/decc717b-1e3f-4c9f-aede-b7687662e372.jpg",
                                      @"news_id":@"90428",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 08:59:38"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227662",
                                      @"title":@"Video: Women's daredevil bikers brigade celebrates India's Republic Day",
                                      @"desc":@"Video: Women's daredevil bikers brigade celebrates India's Republic Day",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/27101655xuqb.jpeg",
                                      @"news_id":@"90462",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 10:14:14"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227756",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/kicssiew131.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227757",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/14dlxekmix2.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227758",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/tu3wg4celrw.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227759",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/lxzclhvfzdm.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227760",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/qsqxmdygs5o.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227761",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/4ugzonff3tk.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227762",
                                      @"title":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"desc":@"Fairy-tale snow scenery of West Lake in Hangzhou",
                                      @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180126/29022411/urgifd0p13z.jpg",
                                      @"news_id":@"90197",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 08:50:54"
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
                          @"image_list_detail":@[],
                          @"return_time":@"2018-01-27 09:01:22"
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
                          @"image_list_detail":@[
                                  @{
                                      @"id":@"227578",
                                      @"title":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"desc":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/270922293tb4.jpeg",
                                      @"news_id":@"90441",
                                      @"channel":@"Top news"
                                      },
                                  @{
                                      @"id":@"227579",
                                      @"title":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"desc":@"Entire USA Gymnastics board to resign amid sexual abuse scandal",
                                      @"url":@"http://med.inewsengine.com/up/cms/www/201801/2709290754m5.jpg",
                                      @"news_id":@"90441",
                                      @"channel":@"Top news"
                                      }
                                  ],
                          @"return_time":@"2018-01-27 09:29:53"
                          },

                      ];
    
    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    [self.dataArr addObjectsFromArray:arrayM];
    [self calculateCellHeightWithModelArray:arrayM];
    PD_NSLog(@"加载数据...........................");
    [self.tableView reloadData];
    
    [self.tableView.mj_header endRefreshingWithCompletionBlock:^{
        self.tableView.mj_header.state = MJRefreshStateIdle;
    }];
}

#pragma mark - 计算cell高度
-(void)calculateCellHeightWithModelArray:(NSArray*)modelArr{
    
    for (INNewsListModel *model in modelArr) {
        NSString *cellHeight;
        CGFloat titleHeight;
        CGFloat imgViewHeight;
        NSInteger listType = model.contenttype.integerValue;
        
        if (listType == INNewsListTypeSpecial) {
            titleHeight = [[INPublicTools sharedPublicTools]calculateLableHeightWithText:model.title Font:[UIFont fontWithName:SFProTextBold size:PD_Fit(SPECIAL_TITLE_FONTSIZE)] width:(self.view.width-2*PD_Fit(BASE_MARGIN))];
            imgViewHeight = self.view.width *3.0/4.0;
            cellHeight = [NSString stringWithFormat:@"%f",imgViewHeight+PD_Fit(BASE_MARGIN)+titleHeight+PD_Fit(BASE_MARGIN)+PD_Fit(17)+PD_Fit(10)];
        }else if (listType == INNewsListTypeNomal){
            cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(100)];
        }else if (listType == INNewsListTypePic){
            titleHeight = [[INPublicTools sharedPublicTools]calculateLableHeightWithText:model.title Font:[UIFont fontWithName:SFProTextSemibold size:PD_Fit(PIC_TITLE_FONTSIZE)] width:(self.view.width-2*PD_Fit(BASE_MARGIN))];
            imgViewHeight = (self.view.width - 2*PD_Fit(BASE_MARGIN))/2;
            cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(BASE_MARGIN)+imgViewHeight+PD_Fit(BASE_MARGIN)+titleHeight+PD_Fit(BASE_MARGIN)+PD_Fit(17)+PD_Fit(10)];
        }else if (listType == INNewsListTypeLive || listType == INNewsListTypeReplay||listType == INNewsListTypeVideo){
            titleHeight = [[INPublicTools sharedPublicTools]calculateLableHeightWithText:model.title Font:[UIFont fontWithName:SFProTextBold size:PD_Fit(LIVE_TITLE_FONTSIZE)] width:(self.view.width-2*PD_Fit(BASE_MARGIN))];
            imgViewHeight = self.view.width*9/16;
            cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(BASE_MARGIN)+imgViewHeight+PD_Fit(BASE_MARGIN)+titleHeight+PD_Fit(BASE_MARGIN)+PD_Fit(17)+PD_Fit(10)];
        }
        [self.newsLayoutArr addObject:cellHeight];
    }
}


#pragma mark - 懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)newsLayoutArr{
    if (!_newsLayoutArr) {
        _newsLayoutArr = [NSMutableArray array];
    }
    return _newsLayoutArr;
}





@end
