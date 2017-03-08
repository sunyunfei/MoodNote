//
//  ObtainLocationManager.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObtainLocationManager : NSObject
//返回地理位置
@property(nonatomic,copy)void(^locationBlock)(NSString *locationStr);
//获取地点
- (void)obtainLocation;
@end
