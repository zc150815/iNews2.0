//
//  INMyFavoritesController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/31.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INMyFavoritesController.h"
#import "INNewsListNomalCell.h"

@interface INMyFavoritesController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *dataLayoutArr;


@end

@implementation INMyFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    
    //主视图
    UITableView *mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor getColor:COLOR_BACKGROUND_BASE];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [mainView registerClass:[INNewsListNomalCell class] forCellReuseIdentifier:@"INNewsListNomalCellID"];
    self.mainView = mainView;
    [self.view addSubview:mainView];
    
    [self.view bringSubviewToFront:self.navBar];
    mainView.contentInset = UIEdgeInsetsMake(self.navBar.height, 0, 0, 0);
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    INNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListNomalCellID" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    cell.hiddenDeleBtn = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataLayoutArr[indexPath.row] floatValue];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArr removeAllObjects];
    [self.dataLayoutArr removeAllObjects];
    [tableView tableViewLoadNoDataWithImage:[UIImage imageNamed:@"icon_myfavorites"] Title:@"No favorite story"];
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArr removeObjectAtIndex:indexPath.row];
        [self.dataLayoutArr removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];

    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Remove";
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
    PD_NSLog(@"搜索数据...........................");
    [self.mainView reloadData];
    [self.mainView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
#pragma mark 计算cell高度
-(void)calculateCellHeightWithModelArray:(NSArray*)modelArr{
    
    for (INNewsListModel *model in modelArr) {
        NSString *cellHeight;
//        CGFloat titleHeight;
//        CGFloat imgViewHeight;
        
        cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(100)];
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
