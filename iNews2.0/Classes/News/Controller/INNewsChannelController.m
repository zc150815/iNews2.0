//
//  INNewsChannelController.m
//  iNews2.0
//
//  Created by 123 on 2018/1/28.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "INNewsChannelController.h"
#import "INNewsChannelCell.h"
#import "INNewsListModel.h"

@interface INNewsChannelController ()<UICollectionViewDelegate,UICollectionViewDataSource,INNewsChannelCellDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation INNewsChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setuupUI];
    
    [self loadData];
    
}

-(void)setuupUI{
    
    //编辑按钮
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.adjustsImageWhenHighlighted = NO;
    editBtn.titleLabel.font = [UIFont fontWithName:SFProTextSemibold size:15];
    [editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    editBtn.frame = CGRectMake(self.navBar.width-self.navBar.height, 0, self.navBar.height, self.navBar.height);
    [editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:editBtn];
    
    
    //主体视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.view.width/3, 50);
    flowLayout.headerReferenceSize = CGSizeMake(self.view.width, PD_Fit(30));
    flowLayout.footerReferenceSize = CGSizeMake(self.view.width, PD_Fit(50));
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBar.frame), self.view.width, self.view.height-self.navBar.height) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[INNewsChannelCell class] forCellWithReuseIdentifier:@"INNewsChannelCellID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableHeaderViewID"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReusableFooterViewID"];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
}

-(void)loadData{
    
    NSArray *array = @[@[@{@"channel":@"TOP NEWS"},
                       @{@"channel":@"CHINA"},
                       @{@"channel":@"WORLD"},
                       @{@"channel":@"BUSINESS"},
                       @{@"channel":@"OPINIONS"}],
                     @[@{@"channel":@"TRAVEL"},
                       @{@"channel":@"PHOTOS"},
                       @{@"channel":@"Services"},
                       @{@"channel":@"Culture"},
                       @{@"channel":@"Sports"},
                       @{@"channel":@"Features"},
                       @{@"channel":@"Tech"},
                       @{@"channel":@"Lifestyle"},
                       @{@"channel":@"LOL"},
                       @{@"channel":@"Health"},
                       @{@"channel":@"Entertainment"},
                       @{@"channel":@"Fashion"},
                       @{@"channel":@"Auto"},]
                     ];
    self.dataArr = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    [self manipulationDataWithDataArr:self.dataArr];
    
}
-(void)manipulationDataWithDataArr:(NSArray*)dataArr{
    
    for (NSInteger i=0; i<dataArr.count; i++) {
        NSArray *array = dataArr[i];
        for (NSInteger j=0; j<array.count; j++) {
            INNewsListModel *model = array[j];
            if (i) {
                model.canEdit = NO;
            }else{
                model.canEdit = j?YES:NO;
            }
            model.isEditing = _isEditing;
        }
    }
    
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataArr.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataArr[section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    INNewsChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"INNewsChannelCellID" forIndexPath:indexPath];
    
    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:self.dataArr[indexPath.section]];
    cell.delegate = self;
    cell.model = arrayM[indexPath.item];
//    cell.backgroundColor = PD_RandomColor;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    PD_NSLog(@"第%ld组第%ld个",indexPath.section,indexPath.item);
//    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:self.dataArr[indexPath.section]];
//    INNewsListModel *model = arrayM[indexPath.item];
    if (indexPath.section>0) {
        [[INPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"增加第%ld组第%ld个",indexPath.section,indexPath.item] duration:3];
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReusableHeaderViewID" forIndexPath:indexPath];
        [header.subviews.firstObject removeFromSuperview];
        [header addSubview:[self collectionView:collectionView addHeaderViewWithIndexPath:indexPath]];
        return header;
    }
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReusableFooterViewID" forIndexPath:indexPath];
    
    return footer;
}
-(UIView*)collectionView:(UICollectionView *)collectionView addHeaderViewWithIndexPath:(NSIndexPath*)indexPath{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, collectionView.width, ((UICollectionViewFlowLayout*)collectionView.collectionViewLayout).headerReferenceSize.height)];
//    headerView.backgroundColor = [UIColor getColor:@"dddddd"];
    
    UIButton *titleLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleLab setTitle:[NSString stringWithFormat:@"%@",indexPath.section?@"MORE CHANNEL":@"MY CHANNEL"] forState:UIControlStateNormal];
    titleLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleLab.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [titleLab setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
    titleLab.titleLabel.font = [UIFont fontWithName:SFProTextLight size:15];
    titleLab.frame = CGRectMake(0, 0, headerView.width/2, headerView.height);
    titleLab.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [headerView addSubview:titleLab];
    
    UIButton *detailLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailLab setTitle:[NSString stringWithFormat:@"%@",indexPath.section?@"Tap to add channel":_isEditing?@"Tap to remove channel":@""] forState:UIControlStateNormal];
    detailLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    detailLab.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [detailLab setTitleColor:[UIColor getColor:COLOR_BROWN_DEEP] forState:UIControlStateNormal];
    detailLab.titleLabel.font = [UIFont fontWithName:SFProTextLight size:13];
    detailLab.frame = CGRectMake(headerView.width/2, 0, headerView.width/2, headerView.height);
    detailLab.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [headerView addSubview:detailLab];

    return headerView;
    
    
}
#pragma mark - INNewsChannelCellDelegate
-(void)removeChannelWithINNewsChannelCell:(INNewsChannelCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    [[INPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"增加第%ld组第%ld个",indexPath.section,indexPath.item] duration:3];
}

#pragma mark - 按钮点击事件
-(void)popCurrentViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editButtonClick:(UIButton*)sender{
    if (_isEditing) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        _isEditing = NO;
    }else{
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        _isEditing = YES;
    }
    [self manipulationDataWithDataArr:self.dataArr];
}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
@end
