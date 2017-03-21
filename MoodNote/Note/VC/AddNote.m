//
//  AddNote.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "AddNote.h"
#import "PlaceholderTextView.h"
#import "ObtainLocationManager.h"
#import "ObtainLTWManager.h"
#import "PhotoShowManager.h"
#import "NoteModel.h"
#import "YFShowView.h"
@interface AddNote (){

    BOOL isImage;//是否有内容
}
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
@property(nonatomic,strong)YFShowView *showView;//显示图片
@end

@implementation AddNote

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseLoadTitle:@"创建日记" andShowLeft:YES andShowRight:YES andreturnTitle:@"完成"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mode = 2;//默认2
    
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

- (void)baseReturnBtn{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseRightBtn{

    //新建保存事件
    if(self.textView.text.length <= 0){
        
        [MBProgressHUD YFshowMessage:self.view showText:@"不准备说点什么吗"];
        return;
    }
    
    //首先判断是不是修改事件
    if (self.oldModel) {
        
        //然后判断数据有没有被修改
        if ([self.oldModel.note_content isEqualToString:self.textView.text] && [self.oldModel.note_image isEqualToString:self.url]) {
            
            [MBProgressHUD YFshowMessage:self.view showText:@"数据貌似没有被修改呀"];
            return;
        }
        //数据被修改了，更新数据
        self.oldModel.note_content = self.textView.text;
        self.oldModel.note_type = @(self.mode);
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
            //发个通知刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNote" object:nil];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^{
            
            [MBProgressHUD YFhiddenOldHUDandShowNewHUD:self.view newText:@"上传失败"];
        }];
    }else{
        
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
            
            if (self.url.length > 0) {
                noteModel.note_image = self.url;
            }else{
            
                self.mode = 2;
            }
            
        }else if (self.mode == 1){
            
            if (self.videoUrl.length > 0) {
               
                noteModel.note_image = self.url;
                noteModel.note_video = self.videoUrl;
            }else{
                
                self.mode = 2;
            }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----ui加载

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
    self.mode = [self.oldModel.note_type intValue];
    //判断类型
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.oldModel.note_image]];
    
    if([self.oldModel.note_type intValue] == 0 || [self.oldModel.note_type intValue] == 1){
    
    
        isImage = YES;
        self.url = self.oldModel.note_image;
        if([self.oldModel.note_type intValue] == 1){
        
            self.videoUrl = self.oldModel.note_video;
        }
    }
    
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
    _locationManager.weatherBlock = ^ (NSString *weatherStr){
    
        if (weatherStr != nil || weatherStr.length > 0) {
            
            weakSelf.weatherLabel.text = weatherStr;
        }
    };
}


#pragma mark ----弹出框设置
- (void)p_loadSheet{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    __block typeof(self)weakSelf = self;
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf p_showPhoto:0];
    }];
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf p_showPhoto:1];
    }];
    UIAlertAction *alert3 = [UIAlertAction actionWithTitle:@"小视频(最多8秒)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf p_showPhoto:2];
    }];
    
    if (isImage) {
        
        UIAlertAction *alert5 = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf p_showData];
        }];
        [alertVC addAction:alert5];
    }
    
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
        isImage = YES;
    };
    
    photoManager.updateBlock = ^(NSString *url){
    
        weakSelf.mode = 0;
        [weakSelf.photoImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        weakSelf.url = url;
    };
    
    photoManager.updateVideoBlock = ^(NSString *url){
    
        weakSelf.mode = 1;
        weakSelf.videoUrl = url;
    };
    [photoManager skipPhotoAlbumVC:mode];
}

//查看
- (void)p_showData{

    if (self.videoUrl.length > 0) {
        
        //说明是视频
        [self p_loadShowView:self.videoUrl andMode:1];
    }else{
    
        [self p_loadShowView:self.url andMode:0];
    }
}

- (void)p_loadShowView:(NSString *)url andMode:(NSInteger)mode{

    if (_showView) {
        [_showView removeFromSuperview];
        _showView = nil;
    }
    
    _showView = [[YFShowView alloc]initWithUrl:url andMode:mode];
    _showView.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_showView];
    
}
@end
