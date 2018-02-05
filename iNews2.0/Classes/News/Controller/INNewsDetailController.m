//
//  INNewsDetailController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsDetailController.h"
#import "INDetailToolsView.h"
#import "INNewsDetailCell.h"
#import "INCommentsCell.h"
#import "INNewsListNomalCell.h"
#import "INDetailHeaderView.h"
#import "INDetailFooterView.h"
#import <WebKit/WebKit.h>

#import "INMyCommentsController.h"

@interface INNewsDetailController ()<UITableViewDelegate,UITableViewDataSource,INDetailToolsViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong) UITableView *mainView;
@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSArray *commentsArr;
@property (nonatomic,strong) NSArray *commentsLayoutArr;

@property (nonatomic,strong) NSArray *readedsArr;

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) CGFloat webHeight;

@property (nonatomic,strong) UIButton *infoBtn;
@end

@implementation INNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self loadData];
    
}

-(void)setupUI{
    
    //编辑按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.adjustsImageWhenHighlighted = NO;
//    editBtn.titleLabel.font = [UIFont fontWithName:SFProTextSemibold size:17];
//    [editBtn setTitle:@"Aa" forState:UIControlStateNormal];
//    [editBtn setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
//    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [editBtn setImage:[UIImage imageNamed:@"switchbutton"] forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(self.navBar.width-self.navBar.height, 0, self.navBar.height, self.navBar.height);
    [editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:editBtn];
    
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.titleLabel.font = [UIFont fontWithName:SFProTextSemibold size:12];
    [infoBtn setTitleColor:[UIColor getColor:@"999999"] forState:UIControlStateNormal];
    infoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, PD_Fit(8), 0, PD_Fit(-8));
    infoBtn.center = CGPointMake(self.navBar.width/2, self.navBar.height/2);
    infoBtn.bounds = CGRectMake(0, 0, self.navBar.width/2, self.navBar.height);
    UIImage *infoImg = [UIImage scaleFromImage:[UIImage imageNamed:@"temp1"] toSize:CGSizeMake(PD_Fit(32), PD_Fit(32))];
    [infoBtn setImage:[infoImg drawCircleImageWithImage:infoImg WithCornerRadius:infoImg.size.height] forState:UIControlStateNormal];
    [infoBtn setTitle:@"Ding Xiaoxiao" forState:UIControlStateNormal];
    infoBtn.alpha = 0;
    self.infoBtn = infoBtn;
    [self.navBar addSubview:infoBtn];
    
    
    ///主视图
    UITableView *mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [mainView registerClass:[INNewsDetailCell class] forCellReuseIdentifier:@"INNewsDetailCellID"];
    [mainView registerClass:[INNewsListNomalCell class] forCellReuseIdentifier:@"INNewsListNomalCellID"];
    [mainView registerClass:[INCommentsCell class] forCellReuseIdentifier:@"INCommentsCellID"];

    self.mainView = mainView;
    [self.view addSubview:mainView];
    
    
    INDetailToolsView *toolsView = [[INDetailToolsView alloc]initWithFrame:CGRectMake(0, self.view.height-PD_Fit(50), self.view.width, PD_Fit(50))];
    toolsView.delegate = self;
    [self.view addSubview:toolsView];
    
    
    [self.view bringSubviewToFront:self.navBar];
    mainView.contentInset = UIEdgeInsetsMake(self.navBar.height, 0, toolsView.height, 0);
}


#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataDic.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section) {
        NSString *key = section==1?@"RelatedStories":@"LatestComments";
        return  [[self.dataDic objectForKey:key]count];
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //阅读过的新闻
    if (indexPath.section == 1) {
        
        INNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsListNomalCellID" forIndexPath:indexPath];
        NSArray *modelArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:[self.dataDic objectForKey:@"RelatedStories"]];
        
        cell.model = modelArr[indexPath.row];
        cell.hiddenDeleBtn = YES;
        return cell;
        
    //最新评论
    }else if (indexPath.section == 2){
        
        INCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INCommentsCellID" forIndexPath:indexPath];
        NSArray *modelArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:[self.dataDic objectForKey:@"LatestComments"]];
        
        cell.model = modelArr[indexPath.row];
        return cell;
        
    }
    
    //新闻内容
    INNewsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNewsDetailCellID" forIndexPath:indexPath];

    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.section?indexPath.section==1?100:[self.commentsLayoutArr[indexPath.row] floatValue]:UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

//    return section?section==1?40:60:20;
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return section?section==1?40:60:20;
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *array = @[@{@"title":@"Electronics ban on flights not a longterm solution: IATA boss"},@{@"title":@"Related Stories"},@{@"title":@"Latest Comments"}];
    NSArray *arrayModel = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    
    INDetailHeaderView *header = [[INDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForHeaderInSection:section])];
    header.model = arrayModel[section];
    
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    INDetailFooterView *footer = [[INDetailFooterView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForFooterInSection:section])];
    
    return footer;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentY = scrollView.contentOffset.y+64;
    if (contentY >50 && contentY <100) {
        CGFloat alpha = contentY/100;
        self.infoBtn.alpha = alpha;
    }
}



#pragma mark - INDetailToolsViewDelegate
-(void)INDetailToolsView:(INDetailToolsView*)toolsView toolsButtonClickWith:(INDetailToolsViewType)type{
    switch (type) {
        case INDetailToolsViewTypeSearch:{
            PD_NSLog(@"searching");
        }
            break;
        case INDetailToolsViewTypeComment:{
            PD_NSLog(@"commenting");
            INMyCommentsController *commentVC =[[INMyCommentsController alloc]init];
            commentVC.title = @"全部评论";
            [self.navigationController pushViewController:commentVC animated:YES];
        }
            break;
        case INDetailToolsViewTypeCollect:{
            PD_NSLog(@"collecting");
        }
            break;
        case INDetailToolsViewTypeShare:{
            PD_NSLog(@"shareing");
        }
            break;
        default:
            break;
    }
}



#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [webView evaluateJavaScript:@"document.getElementById(\"content\").offsetHeight;" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        _webView.frame = CGRectMake(0, 0, PD_ScreenWidth, documentHeight);
        _webHeight = documentHeight;
        [self.mainView reloadData];
    }];
    
}

#pragma mark - 按钮点击方法
-(void)editButtonClick:(UIButton*)sender{
    
}



#pragma mark - lazy
-(NSDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}
-(NSArray *)commentsArr{
    if (!_commentsArr) {
        _commentsArr = [NSArray array];
    }
    return _commentsArr;
}
-(NSArray *)commentsLayoutArr{
    if (!_commentsLayoutArr) {
        _commentsLayoutArr = [NSArray array];
    }
    return _commentsLayoutArr;
}
-(NSArray *)readedsArr{
    if (!_readedsArr) {
        _readedsArr = [NSArray array];
    }
    return _readedsArr;
}




#pragma mark - LoadData
-(void)loadData{
    
    NSDictionary *dic = @{@"Content":@"<p style=\"text-align:center\"><img src=\"http://med.inewsengine.com/up/cms/www/201802/02145349gp00.jpg\" title=\"podcast.jpg\" alt=\"podcast.jpg\" width=\"400\" height=\"267\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 267px;\"/></p><p><audio class=\"edui-upload-audio vjs-default-skin audio-js\" controls=\"\" preload=\"none\" width=\"300\" height=\"80\" src=\"http://med.inewsengine.com/up/cms/www/201802/02224959f13b.mp3\" data-setup=\"{}\"><source src=\"http://med.inewsengine.com/up/cms/www/201802/02224959f13b.mp3\" type=\"audio/mp3\"/></audio></p><p style=\"text-align: left;\">This is People's Daily Tonight, your news source from China. </p><p style=\"text-align: left;\"><strong>_________</strong></p><p><strong>Xi's special envoy to attend PyeongChang Olympics opening ceremony</strong></p><p style=\"text-align:center\"><img src=\"http://med.inewsengine.com/up/cms/www/201802/02145428afhh.jpg\" title=\"奥运会.jpg\" alt=\"奥运会.jpg\" width=\"400\" height=\"225\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 225px;\"/></p><p>Chinese President Xi Jinping's special envoy Han Zheng will attend the opening ceremony of the 23rd Winter Olympics in PyeongChang on Feb. 9, at the invitation of South Korean President and President of the International Olympic Committee.</p><p>Han is a member of the Standing Committee of the Communist Party of China Central Committee Political Bureau.</p><p>_________</p><p style=\"text-align: left;\"><strong>China and UNDP Pakistan sign $4 million agreement to support crisis-affected areas</strong><br/></p><p style=\"text-align:center\"><img src=\"http://med.inewsengine.com/up/cms/www/201802/02195423ipqh.jpg\" title=\"VCG41dv565032.jpg\" alt=\"VCG41dv565032.jpg\" width=\"400\" height=\"267\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 267px;\"/></p><p style=\"text-align: left;\">In a unique example of south-south collaboration, China and the United Nations Development Programme (UNDP) Pakistan have signed a $4 million agreement on Friday to provide assistance in the Federally Administered Tribal Areas (FATA) and Balochistan that have been affected by natural and human-made crises. </p><p style=\"text-align: left;\">The \"China South-South Cooperation Assistance Fund for the Recovery Project\" is going to help 8,100 families returning to the areas to rebuild their lives.</p><p style=\"text-align: left;\">_________</p><p><strong>China launches electromagnetic satellite to study earthquake precursors</strong></p><p style=\"text-align:center\"><img src=\"http://med.inewsengine.com/up/cms/www/201802/02173345brww.jpg\" title=\"发射.jpg\" alt=\"发射.jpg\" width=\"400\" height=\"267\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 267px;\"/></p><p>China on Friday launches its first electromagnetic satellite to study earthquake precursors from Jiuquan Satellite Launch Center.</p><p>The satellite will help establish a ground-space earthquake monitoring and forecasting network in the future.</p><p>_________</p><p style=\"text-align: left;\"><strong>Russia marks 75th anniversary of WWII turning point</strong><br/></p><p style=\"text-align:center\"><img src=\"http://med.inewsengine.com/up/cms/www/201802/021957095ft6.jpg\" title=\"俄罗斯.jpg\" alt=\"俄罗斯.jpg\" width=\"400\" height=\"257\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 257px;\"/></p><p>Russia is celebrating the 75th anniversary of the Soviet Union's victory in the Battle of Stalingrad with a series of events in the southern city of Volgograd.</p><p>The battle that took place between July 17, 1942 and February 2, 1943, is considered by many historians to have been the turning point in World War II in Europe.</p><p>________</p><p style=\"text-align: left;\"><strong>Van slams into pedestrians in Shanghai, 18 hurt</strong><br/></p><p style=\"text-align:center\"><strong><img src=\"http://med.inewsengine.com/up/cms/www/201802/02145707misn.jpg\" title=\"着火1.jpg\" alt=\"着火1.jpg\" width=\"400\" height=\"299\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 299px;\"/></strong></p><p style=\"text-align: left;\">A van rammed pedestrians in Shanghai on Friday morning.</p><p style=\"text-align: left;\">Eighteen people were injured, three of them seriously, when the van, carrying three gas tanks, veered into a sidewalk and caught fire.</p><p style=\"text-align: left;\">Luckily, the gas tanks were unaffected by the blaze. All the injured have been taken to the hospital.</p><p style=\"text-align: left;\">Police said the fire might have started because the driver was smoking. </p><p style=\"text-align: left;\">________</p><p style=\"text-align: left;\"><strong>China's refined oil demand expected to grow 3% in 2018</strong><br/></p><p style=\"text-align:center\"><strong><img src=\"http://med.inewsengine.com/up/cms/www/201802/021955288lfp.jpg\" title=\"VCG11437551321.jpg\" alt=\"VCG11437551321.jpg\" width=\"400\" height=\"266\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 266px;\"/></strong></p><p>China's demand for refined oil is likely to rise 3 percent year on year in 2018 and slow down gradually in the medium- and long-term.</p><p>The United States will rise to be a major crude oil supplier for China after China overtook the former to become the world's largest crude oil importer last year, according to a report released by Chinese oil giant Sinopec and think tank Chinese Academy of Social Sciences.</p><p><strong>________</strong></p><p style=\"text-align: left;\"><strong>Five dead after two army helicopters collide in France</strong></p><p style=\"text-align: center;\"><img src=\"http://med.inewsengine.com/up/cms/www/201802/02201920tnay.jpg\" title=\"AP_18033439946308.jpg\" alt=\"AP_18033439946308.jpg\" width=\"400\" height=\"266\" border=\"0\" vspace=\"0\" style=\"width: 400px; height: 266px;\"/></p><p style=\"text-align: left;\">Five people were killed Friday after two military training helicopters crashed into each other near a lake in southern France. The collision took place near Carces lake about 50 kilometres (30 miles) northwest of the resort of Saint-Tropez. Some 20 troops joined two rescue helicopters and a police chopper at the crash site, along with local officials.</p><p style=\"text-align: left;\">________</p><p style=\"text-align: left;\">And that's People's Daily Tonight. Thank you for joining us.</p><p style=\"text-align: left;\"><span style=\"color: rgb(127, 127, 127);\">(Produced by Ni Tao, Chen Zilin, and Liang Peiyu)</span></p>",
                          @"RelatedStories":@[@{
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
                                                              @"id":@"227516",
                                                              @"title":@"Xi's vision of shared future reverberates in Davos",
                                                              @"desc":@"Xi's vision of shared future reverberates in Davos",
                                                              @"url":@"http://fwimage.cnfanews.com/websiteimg/2018/20180127/20219099/decc717b-1e3f-4c9f-aede-b7687662e372.jpg",
                                                              @"news_id":@"90428",
                                                              @"channel":@"Top news"
                                                              }],
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
                                                          ],
                                                  @"return_time":@"2018-01-27 08:50:54"
                                                  }],
                          @"LatestComments":@[//special(over)
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
                                      },]
                          };
    self.dataDic = dic;
    
    NSArray *comments = [INNewsListModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"LatestComments"]];
    self.commentsArr = comments;
    
    NSArray *readeds = [INNewsListModel mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"RelatedStories"]];
    self.readedsArr = readeds;

    [self calculateCellHeightWithModelArray:comments];
    
    [self.mainView reloadData];
    
}


#pragma mark - 计算cell高度
-(void)calculateCellHeightWithModelArray:(NSArray*)modelArr{
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:modelArr.count];
    for (INNewsListModel *model in modelArr) {
        NSString *cellHeight;
        CGFloat titleHeight;
//        CGFloat imgViewHeight;
        
        titleHeight = [[INPublicTools sharedPublicTools]calculateLableHeightWithText:model.comment Font:[UIFont fontWithName:SFProTextBold size:COMMENT_COMMENT_FONTSIZE] width:(self.view.width-3*PD_Fit(BASE_MARGIN)-PD_Fit(32)) limitRowCount:0];
        
        cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(BASE_MARGIN)+PD_Fit(COMMENT_COMMENT_FONTSIZE)+PD_Fit(BASE_MARGIN)+titleHeight+PD_Fit(BASE_MARGIN)+PD_Fit(10)];
        //        cellHeight = [NSString stringWithFormat:@"%f",PD_Fit(80)];
        [arrayM addObject:cellHeight];
    }
    self.commentsLayoutArr = arrayM.copy;
}
@end
