//
//  AddNote.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "AddNote.h"
#import "PlaceholderTextView.h"
#import "ObtainLocationManager.h"
#import "ObtainLTWManager.h"
#import "PhotoShowManager.h"
#import "NoteModel.h"
@interface AddNote ()
@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;//文字
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;//地图
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;//图片
@property(nonatomic,strong)ObtainLocationManager *locationManager;//获取地图
@property(nonatomic,strong)ObtainLTWManager *ltManager;//获取时间和天气
@property(nonatomic,copy)NSString *url;//图片链接
@property(nonatomic,copy)NSString *videoUrl;//视频链接
@property(nonatomic,assign)NSInteger mode;//选择类型
@property(nonatomic,strong)UIBarButtonItem *saveItem;//保存按钮
@end

@implementation AddNote

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mode = 2;//默认2
    
    [self p_loadSubmitBtn];
    [self p_loadTapForImage];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (!self.oldModel) {
        //地图
        [self p_loadLocation];
        //时间
        self.timeLabel.text = [ObtainLTWManager obtainTime];
        [self p_textSet];
    }else{
    
        [self dataSet];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----ui加载
//添加按钮的添加
- (void)p_loadSubmitBtn{

    _saveItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickSubmitBtn)];
    self.navigationItem.rightBarButtonItem = _saveItem;
}

- (void)p_textSet{

    self.textView.placeholder = @"怀着什么样的心情在写日记呢";
}
- (void)p_loadTapForImage{


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_loadSheet)];
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoImageView addGestureRecognizer:tap];
}
#pragma mark ----数据加载

- (void)dataSet{

    self.textView.text = self.oldModel.note_content;
    self.timeLabel.text = self.oldModel.note_time;
    self.weatherLabel.text = self.oldModel.note_weather;
    self.locationLabel.text = self.oldModel.note_location;
    //判断类型
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.oldModel.note_image]];
    
}
//地图
- (void)p_loadLocation{

    if (!_locationManager) {
        
        _locationManager = [[ObtainLocationManager alloc]init];
    }
    //请求位置
    [_locationManager obtainLocation];
    __block typeof(self)weakSelf = self;
    _locationManager.locationBlock = ^(NSString *locationStr){
    
        weakSelf.locationLabel.text = locationStr;
    };
}

#pragma mark ----事件处理
//添加事件
- (void)clickSubmitBtn{

    //首先判断是不是修改事件
    if (self.oldModel) {
        
        //然后判断数据有没有被修改
        if ([self.oldModel.note_content isEqualToString:self.textView.text] && [self.oldModel.note_image isEqualToString:self.url]) {
            
            [MBProgressHUD YFshowMessage:self.view showText:@"数据貌似没有被修改呀"];
            return;
        }
        //数据被修改了，更新数据
        self.oldModel.note_content = self.textView.text;
        if (self.mode == 0) {
            
            self.oldModel.note_image = self.url;
        }else if (self.mode == 1){
            
            self.oldModel.note_image = self.url;
            self.oldModel.note_video = self.videoUrl;
        }
        //开始修改
        __block typeof(self)weakSelf = self;
        [YFBmobManager updateNoteData:self.oldModel success:^{
            //返回到根控制器
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            if ([weakSelf.delegate respondsToSelector:@selector(refreshDataForRoot)]) {
                
                [weakSelf.delegate refreshDataForRoot];
            }
        } failure:^{
            
            [MBProgressHUD YFhiddenOldHUDandShowNewHUD:self.view newText:@"上传失败"];
        }];
    }else{
    
        //新建保存事件
        if(self.textView.text.length <= 0){
            
            [MBProgressHUD YFshowMessage:self.view showText:@"不准备说点什么吗"];
            return;
        }
        //开始上传
        [MBProgressHUD YFshowHUD:self.view labelText:@"上传中"];
        NoteModel *noteModel = [[NoteModel alloc]init];
        noteModel.note_content = self.textView.text;
        noteModel.note_time = self.timeLabel.text;
        noteModel.note_weather = self.weatherLabel.text;
        noteModel.note_location = self.locationLabel.text;
        //判断类型
        noteModel.note_type = @(self.mode);
        if (self.mode == 0) {
            
            noteModel.note_image = self.url;
        }else if (self.mode == 1){
            
            noteModel.note_image = self.url;
            noteModel.note_video = self.videoUrl;
        }
        noteModel.user_id = [UserDataManager obtainUserId];
        
        __block typeof(self)weakSelf = self;
        [YFBmobManager insertNote:noteModel success:^{
            
            [MBProgressHUD YFhiddenOldHUDandShowNewHUD:self.view newText:@"上传成功"];
            if ([weakSelf.delegate respondsToSelector:@selector(refreshDataForRoot)]) {
                
                [weakSelf.delegate refreshDataForRoot];
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^{
            
            [MBProgressHUD YFhiddenOldHUDandShowNewHUD:self.view newText:@"上传失败"];
        }];
    }
}

#pragma mark ----弹出框设置
- (void)p_loadSheet{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    __block typeof(self)weakSelf = self;
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.mode = 0;
        [weakSelf p_showPhoto:0];
    }];
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.mode = 0;
        [weakSelf p_showPhoto:1];
    }];
    UIAlertAction *alert3 = [UIAlertAction actionWithTitle:@"小视频(最多8秒)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.mode = 1;
        [weakSelf p_showPhoto:2];
    }];
    
    UIAlertAction *alert4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:alert1];
    [alertVC addAction:alert2];
    [alertVC addAction:alert3];
    [alertVC addAction:alert4];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//选择模式
- (void)p_showPhoto:(NSInteger)mode{

    //跳转相册
    PhotoShowManager *photoManager = [PhotoShowManager sharePhotoManager];
    //图像传递
    __block typeof(self)weakSelf = self;
    photoManager.iconBlock = ^(UIImage *icon){
        
        weakSelf.photoImageView.image = icon;
    };
    
    photoManager.updateBlock = ^(NSString *url){
    
        weakSelf.url = url;
    };
    
    photoManager.updateVideoBlock = ^(NSString *url){
    
        weakSelf.videoUrl = url;
    };
    [photoManager skipPhotoAlbumVC:mode];
}
@end
