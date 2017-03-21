//
//  ObtainLocationManager.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "ObtainLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "AFNetworking.h"
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
        NSString *locationStr = @"郑州市";
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
            if (regeocode.city == nil) {
                locationStr = [NSString stringWithFormat:@"%@ %@",regeocode.district,regeocode.street];
            }else{
            
                locationStr = [NSString stringWithFormat:@"%@ %@ %@",regeocode.city,regeocode.district,regeocode.street];
                [weakSelf loadWeather:regeocode.city];
            }
        }
        
        //返回数据
        weakSelf.locationBlock(locationStr);
    };
}

//天气请求
- (void)loadWeather:(NSString *)city{

    //首先把市去掉
    NSString *newCity = [city substringToIndex:city.length - 1];
    
    NSDictionary *dic = @{@"appkey":@"7ad051ebf511b1cb",@"city":newCity};
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    
    __block typeof(self)weakSelf =self;
    [manager POST:@"http://api.jisuapi.com/weather/query?" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *dic2 = responseObject[@"result"];
        NSLog(@"%@ ",dic2[@"weather"]);
        
        if (weakSelf.weatherBlock) {
            weakSelf.weatherBlock(dic2[@"weather"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}
- (void)dealloc{

    [self cleanUpAction];
}
@end
