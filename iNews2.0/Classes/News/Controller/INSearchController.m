//
//  INSearchController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/28.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INSearchController.h"
#import "INNewsListNomalCell.h"

@interface INSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,INNewsListBaseCellDelegate>

@property (nonatomic,strong) UITableView *mainView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UISegmentedControl *segment;

@property (nonatomic,assign) NSInteger selectedIndex;//默认为0,表示当前segmentedCtontrol被选中的标签
@property (nonatomic,assign) BOOL isFinishedSearch;//默认为NO,YES表示为进入搜索功能
@property (nonatomic,strong) NSMutableArray *searchResultArr;//搜索结果数据
@property (nonatomic,strong) NSMutableArray *searchResultLayoutArr;//搜索结果布局数据
@property (nonatomic,strong) NSMutableArray *historyArr;//历史记录数据


@end

@implementation INSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //读取本地存储的搜索历史记录
    [self loadSearchHistoryData];
}
-(void)setupUI{
    
    //搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.backBtn.frame), 0, self.navBar.width-CGRectGetMaxX(self.backBtn.frame), self.navBar.height)];
    searchBar.placeholder = @"Search People'a Daily";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.translucent = YES;
    searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    searchBar.showsCancelButton = YES;
    [self.navBar addSubview:searchBar];
    self.searchBar = searchBar;
    
    
    //主视图
    UITableView *mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.width, self.view.height-CGRectGetMaxY(self.navBar.frame))];
    mainView.bounces = NO;
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [mainView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"INSearchControllerCellID"];
    [mainView registerClass:[INNewsListNomalCell class] forCellReuseIdentifier:@"INNewsListNomalCellID"];
    self.mainView = mainView;
    [self.view addSubview:mainView];

}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //根据当前功能视图用途切换数据源
    return _isFinishedSearch?self.searchResultArr.count:self.historyArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isFinishedSearch) {
        INNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListNomalCellID" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.searchResultArr[indexPath.row];
        cell.hiddenDeleBtn = YES;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INSearchControllerCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage scaleFromImage:[UIImage imageNamed:@"ios7-clock-outline"] toSize:CGSizeMake(15, 15)];
    
    INNewsListModel *model = self.historyArr[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:SFProTextLight size:15];
    cell.textLabel.text = self.segment.selectedSegmentIndex?model.newsWebsite:model.newsTitle;
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.adjustsImageWhenHighlighted = NO;
    [deleBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"closs"] toSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    deleBtn.bounds = CGRectMake(0, 0, 15, 15);
    deleBtn.tag = indexPath.row;
    [deleBtn addTarget:self action:@selector(deleteSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = deleBtn;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isFinishedSearch) {
        return [self.searchResultLayoutArr[indexPath.row] floatValue];
    }
//    return self.segment.selectedSegmentIndex?50:70;
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isFinishedSearch) {
        [[INPublicTools sharedPublicTools]showMessage:@"新闻详情" duration:3];
    }else{
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return _isFinishedSearch||(!self.historyArr.count&&!_isFinishedSearch)?CGFLOAT_MIN:PD_NavHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, [self tableView:tableView heightForHeaderInSection:section])];
    
    headerView.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"News",@"Websites"]];
    segment.center = headerView.center;
    segment.selectedSegmentIndex = _selectedIndex;
    [segment addTarget:self action:@selector(sementedControlClick:) forControlEvents:UIControlEventValueChanged];
    self.segment = segment;
    [headerView addSubview:segment];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return (self.historyArr.count&&!_isFinishedSearch)?50:CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *footerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView setTitle:@"Clearn search history" forState:UIControlStateNormal];
    [footerView setTitleColor:[UIColor getColor:COLOR_BROWN_LIGHT] forState:UIControlStateNormal];
    footerView.titleLabel.font = [UIFont fontWithName:SFProTextRegular size:12];
    footerView.frame = CGRectMake(0, 0, 0, [self tableView:tableView heightForFooterInSection:section]);
    [footerView addTarget:self action:@selector(clearnSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    
    return footerView;
}
#pragma mark - 点击事件
-(void)sementedControlClick:(UISegmentedControl*)segment{
    
    _selectedIndex = segment.selectedSegmentIndex;
//    PD_NSLog(@"%@",[segment titleForSegmentAtIndex:segment.selectedSegmentIndex]);
    [self.view endEditing:YES];
    [self.mainView reloadData];
    
}

-(void)clearnSearchHistory{
    
    [self.historyArr removeAllObjects];
    [self.mainView reloadData];
}
-(void)deleteSearchHistory:(UIButton*)sender{
    
    NSInteger index = sender.tag;
    
    [[INPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"删除第%ld个记录",index] duration:3];

    [self.historyArr removeObjectAtIndex:index];
    
    if (self.historyArr.count == 0){
        [self clearnSearchHistory];
    }else{
        [self.mainView reloadData];
    }
}
-(void)insertSearchHistoryWithContent:(NSString*)content{
    [self.historyArr addObject:content];
    PD_NSLog(@"增加搜索历史记录数据%@",content);
}


#pragma mark UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar endEditing:YES];
    _isFinishedSearch = YES;
    [self.mainView reloadData];
    
    //加载搜索数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadSearchResultData];
    });
    
    [self insertSearchHistoryWithContent:searchBar.text];
}

#pragma mark - LodaData
-(void)loadSearchResultData{
    
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
    [self.searchResultArr addObjectsFromArray:arrayM];
    [self calculateCellHeightWithModelArray:arrayM];
    PD_NSLog(@"搜索数据...........................");
    [self.mainView reloadData];
    [self.mainView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void)loadSearchHistoryData{
    
    NSArray *array = @[@{@"newsTitle":@"Kobe",@"newsWebsite":@"http://www.taobao.com"},
                       @{@"newsTitle":@"Balaling",@"newsWebsite":@"http://www.jd.com"},
                       @{@"newsTitle":@"Youth",@"newsWebsite":@"http://gidhub.com"},
                       @{@"newsTitle":@"Feng Xiao Gang",@"newsWebsite":@"http://www.baidu.com"},
                       @{@"newsTitle":@"Hollywood",@"newsWebsite":@"http://www.jianshu.com"},
                       @{@"newsTitle":@"Beijing",@"newsWebsite":@"https://www.apple.com/cn/"},
                       @{@"newsTitle":@"GreatWall",@"newsWebsite":@"https://developer.apple.com"}];
    
    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    [self.historyArr addObjectsFromArray:arrayM];
    PD_NSLog(@"搜索记录..........................");
    [self.mainView reloadData];
    [self.mainView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}
#pragma mark 计算cell高度
-(void)calculateCellHeightWithModelArray:(NSArray*)modelArr{
    
    for (INNewsListModel *model in modelArr) {
        NSString *cellHeight;
        CGFloat titleHeight;
        CGFloat imgViewHeight;
        
        cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(100)];
        [self.searchResultLayoutArr addObject:cellHeight];
    }
}

#pragma mark - Lazy
-(NSMutableArray *)historyArr{
    if (!_historyArr) {
        _historyArr = [NSMutableArray array];
    }
    return _historyArr;
}
-(NSMutableArray *)searchResultArr{
    if (!_searchResultArr) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
}
-(NSMutableArray *)searchResultLayoutArr{
    if (!_searchResultLayoutArr) {
        _searchResultLayoutArr = [NSMutableArray array];
    }
    return _searchResultLayoutArr;
}
@end
