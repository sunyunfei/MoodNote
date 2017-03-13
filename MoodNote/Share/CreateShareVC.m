//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/12.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "CreateShareVC.h"
#import "PlaceholderTextView.h"
#import "CreateCell.h"
#import "YFSelfImage.h"
#import "ALAssetsLibrary+YF.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSObject+YFPhoto.h"
#import "YFShowGroupAlbumVC.h"
#import "EvaluatePhotoView.h"
#define K_WIDTH [UIScreen mainScreen].bounds.size.width
#define K_HEIGHT [UIScreen mainScreen].bounds.size.height
static NSString *createCell = @"CreateCell";
@interface CreateShareVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{

    NSMutableArray *imageArray; //数组
    YFShowGroupAlbumVC *showVC; //显示相册分组的控制器
    UINavigationController *navShow; //因为相册分组是模态出来的，所以给他一个导航，让相册详细界面可以导航出来
}
@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)EvaluatePhotoView *photoView;//图片显示类
- (IBAction)clickSubmitBtn:(id)sender;
- (IBAction)clickCancelBtn:(id)sender;
@end

@implementation CreateShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageArray = [NSMutableArray array];
    showVC = [[YFShowGroupAlbumVC alloc]init];
    navShow = [[UINavigationController alloc]initWithRootViewController:showVC];
    
    [self p_setUI];
    [self p_loadPhotoBtn];
    //接受通知 一个是把宰相册详情选择的图片传过来，一个是把相机照的图片传过来
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notShow:) name:@"pushImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveImageSure:) name:@"SAVEIMAGE" object:nil];
}
/**
 *  获得选中的图片数组
 *
 *  @param user <#user description#>
 */
- (void)notShow:(NSNotification *)user{
    
//    [imageArray removeAllObjects];
    NSDictionary *dic = user.userInfo;
    [imageArray addObjectsFromArray:dic[@"cellImage"]];
    [_collectionView reloadData];
}
/**
 *  获得相机图片
 *
 */
- (void)saveImageSure:(NSNotification *)user{
    
    NSDictionary *dic = user.userInfo;
    YFSelfImage *image = dic[@"saveImage"];
    [imageArray addObject:image];
    [_collectionView reloadData];
}

#pragma mark ----ui设置
//添加按钮的添加
- (void)p_loadPhotoBtn{
    
    UIBarButtonItem *photoBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(clickPhotoBtn)];
    self.navigationItem.rightBarButtonItem = photoBtn;
}
- (void)p_setUI{

    _textView.placeholder = @"分享点什么呢";
    //九宫格设置
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat cellX = CGRectGetWidth(self.view.frame) / 5 - 1;
    layout.itemSize = CGSizeMake(cellX,cellX);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:createCell bundle:nil] forCellWithReuseIdentifier:createCell];
    
}
#pragma mark ----事件
- (void)clickPhotoBtn{

    showVC.showAlbumStyle = ENUM_PhotoAndCamera;
    showVC.albumColor = [UIColor whiteColor];
    showVC.listCount = 4;
    showVC.maxCount = imageArray.count;
    [self presentViewController:navShow animated:YES completion:nil];
}
#pragma mark --  代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CreateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:createCell forIndexPath:indexPath];
    cell.clearBtn.tag = indexPath.row;
    //删除
    __weak typeof(self)weakSelf = self;
    cell.deleBlock = ^(NSInteger index){
        
        //删除数组中对应的元素
        [imageArray removeObjectAtIndex:index];
        [weakSelf.collectionView reloadData];
    };
    YFSelfImage *image = imageArray[indexPath.row];
    cell.imageView.image = image;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //显示大图
    self.photoView= [[EvaluatePhotoView alloc]init];
    self.photoView.modeShow = 0;
    self.photoView.photoArray = imageArray;
    self.photoView.indexTag = indexPath.row;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//提交
- (IBAction)clickSubmitBtn:(id)sender {
    
    if (self.textView.text.length <= 0) {
        
        [MBProgressHUD YFshowMessage:self.view showText:@"不准备说点什么吗"];
        return;
    }
    
    //开始上传
    
}

//取消
- (IBAction)clickCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
