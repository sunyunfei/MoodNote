//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
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
#import "FamilyGroup.h"
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
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property(nonatomic,strong)EvaluatePhotoView *photoView;//图片显示类
- (IBAction)clickSubmitBtn:(id)sender;
- (IBAction)clickCancelBtn:(id)sender;
@end

@implementation CreateShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseLoadTitle:@"创建分享" andShowLeft:YES andShowRight:YES andreturnTitle:@"照片"];
    imageArray = [NSMutableArray array];
    showVC = [[YFShowGroupAlbumVC alloc]init];
    navShow = [[UINavigationController alloc]initWithRootViewController:showVC];
    
    [self p_setUI];
    //接受通知 一个是把宰相册详情选择的图片传过来，一个是把相机照的图片传过来
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notShow:) name:@"pushImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveImageSure:) name:@"SAVEIMAGE" object:nil];
    
    //颜色
    self.sureBtn.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
    self.cancelBtn.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
}

- (void)baseRightBtn{

    showVC.showAlbumStyle = ENUM_PhotoAndCamera;
    showVC.albumColor = [UIColor whiteColor];
    showVC.listCount = 4;
    showVC.maxCount = imageArray.count;
    [self presentViewController:navShow animated:YES completion:nil];
}
/**
 *  获得选中的图片数组
 *
 */
- (void)notShow:(NSNotification *)user{
    
    NSDictionary *dic = user.userInfo;
    NSArray *array = (NSArray *)dic[@"cellImage"];
    if ((imageArray.count + array.count) > 8) {
        
        [MBProgressHUD YFshowMessage:self.view showText:@"最多一共可以选择8张图片"];
        return;
    }
    [imageArray addObjectsFromArray:array];
    [_collectionView reloadData];
}
/**
 *  获得相机图片
 *
 */
- (void)saveImageSure:(NSNotification *)user{
    
    NSDictionary *dic = user.userInfo;
    YFSelfImage *image = dic[@"saveImage"];
    [self addObject:image];
    [_collectionView reloadData];
}

//判断图片是不是超过了8个
- (void)addObject:(UIImage *)image{

    if (imageArray.count >= 8) {
        
        [MBProgressHUD YFshowMessage:self.view showText:@"最多一共可以选择8张图片"];
    }else{
    
        [imageArray addObject:image];
    }
}
#pragma mark ----ui设置
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
    //首先上传message数据
    FamilyGroup *model = [[FamilyGroup alloc]init];
    model.name = [UserDataManager obtainUserName];
    model.userId = [UserDataManager obtainUserId];
    model.icon = [UserDataManager obtainUserIcon];
    model.shuoshuoText = self.textView.text;
    [MBProgressHUD YFshowHUD:self.view labelText:@"上传中..."];
    [YFBmobManager insertShare:model andImageArray:imageArray sucess:^{
        
        [MBProgressHUD YFhiddenHUD:self.view];
        if ([self.delegate respondsToSelector:@selector(refreshShareVC)]) {
            [self.delegate refreshShareVC];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        
        [MBProgressHUD YFhiddenOldHUDandShowNewHUD:self.view newText:@"上传失败"];
    }];
}

//取消
- (IBAction)clickCancelBtn:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
