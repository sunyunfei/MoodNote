
//
//  ObtainLTWManager.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "ObtainLTWManager.h"
@interface ObtainLTWManager()

@end
@implementation ObtainLTWManager

//获取时间
+ (NSString *)obtainTime{

    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}

//获取地点
+ (NSString *)obtainLocation{

    return nil;
}

//获取天气
+ (NSString *)obtainWeather{

    return  nil;
}
@end
