//
//  INSettingController.m
//  iNews2.0
//
//  Created by 123 on 2018/2/1.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INSettingController.h"

@interface INSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation INSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    
    //主视图
    UITableView *mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    mainView.bounces = NO;
    mainView.delegate = self;
    mainView.dataSource = self;
    mainView.backgroundColor = [UIColor getColor:COLOR_BACKGROUND_BASE];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    mainView.rowHeight = 50;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INNotificationsCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"INNotificationsCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    INNewsListModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont fontWithName:SFProTextRegular size:17];
    cell.textLabel.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    
    cell.detailTextLabel.text = model.detail;
    cell.detailTextLabel.font = [UIFont fontWithName:SFProTextRegular size:16];
    cell.detailTextLabel.textColor = [UIColor getColor:@"C8C8C8"];
    cell.accessoryType = model.contenttype.boolValue?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    
    if (indexPath.row == 2) {
        UISwitch *swich = [[UISwitch alloc]init];
        [swich addTarget:self action:@selector(ReceiveNotifications:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = swich;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, [self tableView:tableView heightForHeaderInSection:section])];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, [self tableView:tableView heightForFooterInSection:section])];
    footer.backgroundColor = [UIColor clearColor];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.frame = CGRectMake(0, 15, footer.width, footer.height-30);
    [logout setTitle:@"Log Out" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor getColor:COLOR_BASE] forState:UIControlStateNormal];
    logout.titleLabel.font = [UIFont fontWithName:SFProTextSemibold size:17];
    [logout setBackgroundColor:[UIColor whiteColor]];
    [logout addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:logout];
                                
    return footer;
}
#pragma mark - LodaData
-(void)loadData{
    
    NSArray *array =@[
                      @{@"title":@"Font Size",@"detail":@"Medium",@"contenttype":@"1"},
                      @{@"title":@"Clear Cache",@"detail":@"43.3M",@"contenttype":@"0"},
                      @{@"title":@"Receive Notifications",@"detail":@"",@"contenttype":@"0"},
                      @{@"title":@"Video Autoplay",@"detail":@"Wi-Fi only",@"contenttype":@"1"},
                      @{@"title":@"Rate Us",@"detail":@"",@"contenttype":@"01"},
                      @{@"title":@"Terms of Service",@"detail":@"",@"contenttype":@"1"},
                      @{@"title":@"Privacy Policy",@"detail":@"",@"contenttype":@"1"},
                      @{@"title":@"About Us",@"detail":@"",@"contenttype":@"1"},
                      @{@"title":@"Version",@"detail":@"3.0.1",@"contenttype":@"0"},
                      ];
    
    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    [self.dataArr addObjectsFromArray:arrayM];
    PD_NSLog(@"设置数据...........................");
    [self.mainView reloadData];
    [self.mainView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma mark - lazy
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)ReceiveNotifications:(UISwitch*)sender{
    
    NSLog(@"%d",sender.on);
}
-(void)logoutButtonClick{
    NSLog(@"登出...............");
}
@end
