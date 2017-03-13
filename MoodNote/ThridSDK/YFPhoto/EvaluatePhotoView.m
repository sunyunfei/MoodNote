//
//  EvaluatePhotoView.m
//  LiveYoung
//
//  Created by 孙云 on 16/9/13.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "EvaluatePhotoView.h"
#import "EvaluatePhotoCell.h"
#define K_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_HEIGHT [UIScreen mainScreen].bounds.size.height
static NSString * const eva_photoCell = @"EvaluatePhotoCell";
@interface EvaluatePhotoView()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UIButton *deleteBtn;
@property(nonatomic,strong)UICollectionView *collectionView;//滑动
@property(nonatomic,assign)int oldCount;//初始数组个数
//顶部显示
@property(nonatomic,strong)UILabel *centerLabel;
@property(nonatomic,strong)UIView *topView;
@end
@implementation EvaluatePhotoView
- (instancetype)init{

    self = [super init];
    if (self) {
        self.alpha = 0.0;//先设置隐藏
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:17.0 / 255 green:17.0 / 255 blue:17.0 / 255 alpha:1.0];
        //顶部视图加载
        self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
        self.topView.backgroundColor = [UIColor colorWithRed:20.0 / 255 green:20.0 / 255 blue:21.0 / 255 alpha:1.0];
        [self addSubview:self.topView];
        //大按钮扩大热区
        UIButton *bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bigBtn.frame = CGRectMake(0, 0, 55, 55);
        [bigBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:bigBtn];
        //返回按钮
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(15, (55 - 19.5) / 2, 12, 19.5);
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"return_btn_commentimage"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:returnBtn];
        
        //大按钮扩大热区
        UIButton *bigDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bigDeleteBtn.frame = CGRectMake(self.frame.size.width - 55, 0, 55, 55);
        [bigDeleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:bigDeleteBtn];
        
        self.centerLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 100) / 2, 0, 100, 55)];
        self.centerLabel.textAlignment = NSTextAlignmentCenter;
        self.centerLabel.textColor = [UIColor whiteColor];
        
        [self.topView addSubview:self.centerLabel];
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 54, self.frame.size.width, 1)];
        footView.backgroundColor = [UIColor whiteColor];
        footView.alpha = 0.1;
        [self.topView addSubview:footView];
        
        //滑动视图
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - 55);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 55, self.frame.size.width, self.frame.size.height - 55) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        //注册
        [self.collectionView registerNib:[UINib nibWithNibName:eva_photoCell bundle:nil] forCellWithReuseIdentifier:eva_photoCell];
        [self addSubview:self.collectionView];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    }
    return self;
}
//按钮事件
- (void)clickReturnBtn{
    
    //动画消失
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
//数据
- (void)setPhotoArray:(NSMutableArray *)photoArray{

    //动画出现界面
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
    _photoArray = photoArray;
    self.oldCount = (int)photoArray.count;
    [self.collectionView reloadData];
}
- (void)setIndexTag:(NSInteger)indexTag{

    _indexTag = indexTag;
    //展示的时候偏移到对应的界面
    [self.collectionView setContentOffset:CGPointMake(_indexTag * self.collectionView.frame.size.width, 0)];
    self.centerLabel.text = [NSString stringWithFormat:@"%li/%lu",(_indexTag + 1),(unsigned long)_photoArray.count];
}

#pragma mark -----九宫格代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    EvaluatePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:eva_photoCell forIndexPath:indexPath];
    //判断是哪种模式显示
    if(self.modeShow == 0){
    
        cell.photo = self.photoArray[indexPath.row];
    }else{
    
       cell.urlStr = self.photoArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark ------滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int offsetInt = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    if (_indexTag != offsetInt) {
        self.centerLabel.text = [NSString stringWithFormat:@"%i/%lu",offsetInt + 1,(unsigned long)_photoArray.count];
    }
    _indexTag = offsetInt;
    //如果左侧没有图片左拉消失界面
    if (self.collectionView.contentOffset.x < -100 *( K_WIDTH / 320)) {
        [self clickReturnBtn];
    }
}
//点击事件
- (void)tapIamgeEvent{

    [self clickReturnBtn];
}

//隐藏视图
- (void)hiddenPhotoViewForEventView{

    [self clickReturnBtn];
}
//隐藏
- (void)hiddenPhotoViewForOrderEvaluate{

    [self clickReturnBtn];
}
@end
