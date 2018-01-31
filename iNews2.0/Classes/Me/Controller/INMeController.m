//
//  INMeController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/24.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INMeController.h"
#import "INMyFavoritesController.h"

@interface INMeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation INMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *mainView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    mainView.backgroundColor = [UIColor blueColor];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.backgroundColor = [UIColor getColor:@"F2F2F2"];
    mainView.bounces = NO;
    mainView.delegate = self;
    mainView.dataSource = self;
    [mainView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"INMeControllerCellID"];
    [self.view addSubview:mainView];
    
    

    //用户信息视图
    UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfo.adjustsImageWhenHighlighted = NO;
    userInfo.frame = CGRectMake(0, 0, self.view.width, 200);
    [userInfo setBackgroundColor:[UIColor whiteColor]];
    //用户名
    userInfo.titleLabel.font = PD_Font(15);
    [userInfo setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
    [userInfo setTitle:@"用户名" forState:UIControlStateNormal];
    //用户头像
    UIImage *userImg = [UIImage scaleFromImage:[UIImage imageNamed:@"temp1"] toSize:CGSizeMake(PD_Fit(60), PD_Fit(60))];
    [userInfo setImage:[[UIImage alloc]drawCircleImageWithImage:userImg WithCornerRadius:userImg.size.width] forState:UIControlStateNormal];
    userInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [userInfo setTitleEdgeInsets:UIEdgeInsetsMake(userInfo.imageView.frame.size.height+PD_Fit(50),-userInfo.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [userInfo setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -userInfo.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    mainView.tableHeaderView = userInfo;
    

}
-(void)loadData{
    
    self.dataArr = @[@{@"titleStr":@"My Favorites",@"imageStr":@"icon_myfavorites"},
                     @{@"titleStr":@"My Comments",@"imageStr":@"icon_mycomments"},
                     @{@"titleStr":@"Notifications",@"imageStr":@"icon_notifications"},
                     @{@"titleStr":@"Settings",@"imageStr":@"icon_settiongs"}
                     ];
}

#pragma mark - UITableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"INMeControllerCellID" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];

    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"imageStr"]];
    cell.textLabel.text = [dic objectForKey:@"titleStr"];
    cell.textLabel.font = [UIFont fontWithName:SFProTextRegular size:PD_Fit(17)];
    cell.textLabel.textColor = [UIColor getColor:COLOR_BROWN_DEEP];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PD_Fit(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PD_Fit(20);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, [self tableView:tableView heightForHeaderInSection:section])];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            INMyFavoritesController *favoriteVC = [[INMyFavoritesController alloc]init];
            favoriteVC.title = [dic objectForKey:@"titleStr"];
            [self.navigationController pushViewController:favoriteVC animated:YES];
        }
            break;
        case 1:{
            
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            
        }
            break;
        default:
            break;
    }
}




@end
