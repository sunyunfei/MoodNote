//
//  ObtainLocationManager.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObtainLocationManager : NSObject
//返回地理位置
@property(nonatomic,copy)void(^locationBlock)(NSString *locationStr);
@property(nonatomic,copy)void(^weatherBlock)(NSString *weatherStr);
//获取地点
- (void)obtainLocation;
@end
