//
//  ObtainLocationManager.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "ObtainLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface ObtainLocationManager()<AMapLocationManagerDelegate>
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end
@implementation ObtainLocationManager
//构造
- (instancetype)init{

    self = [super init];
    if (self) {
        
        [self configLocationManager];
        [self initCompleteBlock];
    }
    return self;
}

//获取地点
- (void)obtainLocation{

    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}



- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
    
}


- (void)initCompleteBlock
{
    __block typeof(self)weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        NSString *locationStr = @"未获取到位置，点击刷新";
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            //如果为定位失败的error
            if (error.code == AMapLocationErrorLocateFailed)
            {
                //返回数据
                weakSelf.locationBlock(locationStr);
                return;
            }
        }
        
        //得到定位信息，添加annotation
        if (location)
        {
            locationStr = [NSString stringWithFormat:@"%@ %@ %@",regeocode.city,regeocode.district,regeocode.street];
            [weakSelf loadWeather:regeocode.city];
        }
        
        //返回数据
        weakSelf.locationBlock(locationStr);
    };
}

//天气请求http://apistore.baidu.com/microservice/weather?cityname=上海
- (void)loadWeather:(NSString *)city{

    //首先把市去掉
    NSString *newCity = [city substringToIndex:city.length - 1];
    //网络请求
    NSString *urlStr = [NSString stringWithFormat:@"http://apistore.baidu.com/microservice/weather?cityname=%@",newCity];
    NSLog(@"str = %@",urlStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSLog(@"%@",data);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dic);
        }
        
    }];
    
    //发送请求
    [task resume];
}
- (void)dealloc{

    [self cleanUpAction];
}
@end
