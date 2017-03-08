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
@interface AddNote ()
@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;//文字
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;//地图
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;//图片
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;//视频
@property(nonatomic,strong)ObtainLocationManager *locationManager;//获取地图
@property(nonatomic,strong)ObtainLTWManager *ltManager;//获取时间和天气
@end

@implementation AddNote

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //地图
    [self p_loadLocation];
    //时间
    self.timeLabel.text = [ObtainLTWManager obtainTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----ui加载

#pragma mark ----数据加载
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

@end
