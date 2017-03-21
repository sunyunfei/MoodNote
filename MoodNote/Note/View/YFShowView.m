//
//  YFShowView.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/15.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "YFShowView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
@interface YFShowView()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property(nonatomic,copy)NSString *urlStr;
@end
@implementation YFShowView

- (instancetype)initWithUrl:(NSString *)url andMode:(NSInteger)mode{

    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        if (mode == IMAGE_MODE) {
            
            //是图片
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            [self addSubview:imageView];
            
        }else{
        
            //播放
            self.urlStr = url;
            [self.moviePlayer play];
        }
        
        //添加返回按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 40, 40, 40);
        [btn setImage:[UIImage imageNamed:@"icofiction_zwarrows_v5"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}


-(NSURL *)getNetworkUrl{

    NSString *urlStr2 =[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr2];
    return url;
}
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        NSURL *url=[self getNetworkUrl];
        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
        _moviePlayer.view.frame=[UIScreen mainScreen].bounds;
        [self addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}


- (void)clickReturnBtn{

    self.alpha = 0.0;
    [self removeFromSuperview];

}
@end
