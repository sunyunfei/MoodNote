//
//  ObtainLTWManager.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObtainLTWManager : NSObject
//获取时间
+ (NSString *)obtainTime;
//获取地点
+ (NSString *)obtainLocation;
//获取天气
+ (NSString *)obtainWeather;
@end
