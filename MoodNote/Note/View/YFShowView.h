//
//  YFShowView.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/15.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,showMode){

    IMAGE_MODE,
    VIDEO_MODE
};

@interface YFShowView : UIView
- (instancetype)initWithUrl:(NSString *)url andMode:(NSInteger)mode;
@end
