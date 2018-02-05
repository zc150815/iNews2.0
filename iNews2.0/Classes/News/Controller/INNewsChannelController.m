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
@property (nonatomic,strong) NSMutableArray *dataArr;
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
    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:array];
    [self.dataArr addObjectsFromArray:arrayM];
    
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

    
    if (_isEditing) {
        UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [collectionView addGestureRecognizer:longPress];
    }

    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    PD_NSLog(@"第%ld组第%ld个",indexPath.section,indexPath.item);
//    NSArray *arrayM = [INNewsListModel mj_objectArrayWithKeyValuesArray:self.dataArr[indexPath.section]];
//    INNewsListModel *model = arrayM[indexPath.item];
    if (indexPath.section>0) {
//        [[INPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"增加第%ld组第%ld个",indexPath.section,indexPath.item] duration:3];
        //记录要移动的数据
        id object= self.dataArr[indexPath.section][indexPath.item];
        //删除要移动的数据
        [self.dataArr[indexPath.section] removeObjectAtIndex:indexPath.item];
        //添加新的数据到指定的位置
        [self.dataArr[0] addObject:object];
        [self manipulationDataWithDataArr:self.dataArr];
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

    return [self.dataArr[indexPath.section] count]?headerView:nil;
    
    
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    /* 两个indexpath参数, 分别代表源位置, 和将要移动的目的位置*/
    //-1 是为了不让最后一个可以交换位置
    if (proposedIndexPath.section == 0 && proposedIndexPath.item == 0) {
        //初始位置
        return originalIndexPath;
    } else {
        //-1 是为了不让最后一个可以交换位置
        if (originalIndexPath.section == 0 && originalIndexPath.item == 0) {
            return originalIndexPath;
        }
        //      移动后的位置
        return proposedIndexPath;
    }
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //记录要移动的数据
    id object= self.dataArr[sourceIndexPath.section][sourceIndexPath.item];
    //删除要移动的数据
    [self.dataArr[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.item];
    //添加新的数据到指定的位置
    [self.dataArr[sourceIndexPath.section] insertObject:object atIndex:destinationIndexPath.item];
}

#pragma mark - INNewsChannelCellDelegate
-(void)removeChannelWithINNewsChannelCell:(INNewsChannelCell *)cell{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    //记录要移动的数据
    id object= self.dataArr[indexPath.section][indexPath.item];
    //删除要移动的数据
    [self.dataArr[indexPath.section] removeObjectAtIndex:indexPath.item];
    //添加新的数据到指定的位置
    [self.dataArr[1] addObject:object];
    
    [self manipulationDataWithDataArr:self.dataArr];
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
- (void)longPress:(UIGestureRecognizer *)longPress {
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:self.collectionView];
    //从长按开始
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
        if (@available(iOS 9.0, *)) {
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        } else {
            // Fallback on earlier versions
        }
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        if (@available(iOS 9.0, *)) {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
        } else {
            // Fallback on earlier versions
        }
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        
        if (@available(iOS 9.0, *)) {
            [self.collectionView endInteractiveMovement];
        } else {
            // Fallback on earlier versions
        }
        
        //其他情况
    } else {
        if (@available(iOS 9.0, *)) {
            [self.collectionView cancelInteractiveMovement];
        } else {
            // Fallback on earlier versions
        }
    }
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
