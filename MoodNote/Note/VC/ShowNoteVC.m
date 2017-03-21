//
//  ShowNoteVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/9.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "ShowNoteVC.h"
#import "AddNote.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ShowImageViewController.h"

@interface ShowNoteVC (){

    CGFloat contentY;//内容的y值
}
@property(nonatomic,strong)UILabel *contentLabel;//内容
@property(nonatomic,strong)UIImageView *imageView;//图片或者视频
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *weatherLabel;//天气
@property(nonatomic,strong)UILabel *locationLabel;//位置
@property(nonatomic,strong)UIScrollView *scrollView;//滑动背景
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@end

@implementation ShowNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseLoadTitle:@"创建日记" andShowLeft:YES andShowRight:YES andreturnTitle:@"修改"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self p_loadScrollView];
    [self p_LoadLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)baseReturnBtn{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseRightBtn{

    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddNote" bundle:nil];
    AddNote *addVC = [story instantiateViewControllerWithIdentifier:@"add"];
    addVC.oldModel = self.noteModel;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)setNoteModel:(NoteModel *)noteModel{

    _noteModel = noteModel;
    
    //默认的内容的y位置
    contentY = 64;
    //判断类别
    switch ([noteModel.note_type intValue]) {
        case 0:
        {
        
            //图片
            [self p_loadImageView];
            
            [self p_setRectForLabel];
            //图片赋予
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteModel.note_image]];
        }
            break;
        case 1:{
        
            //视频
            //图片
            [self.moviePlayer play];
            [self p_setRectForLabel];
            //图片赋予
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteModel.note_image]];
        }
            break;
        case 2:{
        
            //文字
            [self p_setRectForLabel];
        }
            break;
        default:
            break;
    }
    
    self.contentLabel.text = noteModel.note_content;
    self.timeLabel.text = noteModel.note_time;
    self.weatherLabel.text = noteModel.note_weather;
    self.locationLabel.text = noteModel.note_location;
}

#pragma mark ----加载ui

/**
 *  取得网络文件路径
 */
-(NSURL *)getNetworkUrl{
    NSString *urlStr=self.noteModel.note_video;
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}

/**
 *  创建媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        NSURL *url = [self getNetworkUrl];
        _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame = CGRectMake(0, contentY, CGRectGetWidth(self.view.frame), 200);
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayer.view];
        contentY = contentY + 200;
    }
    return _moviePlayer;
}

- (void)p_loadScrollView{

    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    //_scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_scrollView];
}
//加载imageView
- (void)p_loadImageView{

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, contentY, CGRectGetWidth(self.view.frame), 200)];
    //self.imageView.backgroundColor = [UIColor redColor];
    //self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.clipsToBounds = YES;
    [_scrollView addSubview:self.imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tap];
    contentY = contentY + 200;
}


//加载内容
- (void)p_LoadLabel{

    self.contentLabel = [[UILabel alloc]init];
    //self.contentLabel.backgroundColor = [UIColor yellowColor];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.numberOfLines = 0;
    [_scrollView addSubview:self.contentLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.weatherLabel = [[UILabel alloc]init];
    self.weatherLabel.font = [UIFont systemFontOfSize:12];
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:self.timeLabel];
    [_scrollView addSubview:self.weatherLabel];
    [_scrollView addSubview:self.locationLabel];
}

//位置布局
- (void)p_setRectForLabel{

    CGSize contentSize = [self.noteModel.note_content boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    self.contentLabel.frame = CGRectMake(8, contentY, contentSize.width, contentSize.height);
    
    self.timeLabel.frame = CGRectMake(8, contentY + contentSize.height + 8, CGRectGetWidth(self.view.frame) - 16, 20);
    self.locationLabel.frame = CGRectMake(8, CGRectGetHeight(self.timeLabel.frame) + self.timeLabel.frame.origin.y + 8, CGRectGetWidth(self.view.frame) - 16, 20);
    self.weatherLabel.frame = CGRectMake(8, CGRectGetHeight(self.locationLabel.frame) + self.locationLabel.frame.origin.y + 8, CGRectGetWidth(self.view.frame) - 16, 20);
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.weatherLabel.frame.origin.y + CGRectGetHeight(self.weatherLabel.frame));
}

#pragma mark ----事件

- (void)tapImageView{
    
    
    if ([self.noteModel.note_type intValue] == 0) {
        
        //图片
        self.navigationController.navigationBarHidden = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
        [vc setHidesBottomBarWhenPushed:YES]; //隐藏tabbar
        vc.clickTag = imageTag;
        vc.imageViews = @[self.noteModel.note_image];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.noteModel.note_type intValue] == 1){
    
        //视频
        
    }
    
}

@end
