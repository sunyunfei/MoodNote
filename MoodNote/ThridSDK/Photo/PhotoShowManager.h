//
//  PhotoShowManager.h
//  YangLiWu
//
//  Created by 孙云 on 16/9/6.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,PhotoMode){

    X_C_MODE,//相册
    X_J_MODE,//相机
    S_P_MODE//视频
};
@interface PhotoShowManager : NSObject
//图片传递
@property(nonatomic,copy)void((^iconBlock)(UIImage *icon));
@property(nonatomic,copy)void(^updateBlock)(NSString *url);
@property(nonatomic,copy)void(^updateVideoBlock)(NSString *url);
//图片完成传递事件
//@property(nonatomic,copy)void((^photoSubmitBlock)(NSString *imageName));
//单类
+ (instancetype)sharePhotoManager;
//跳转相册
- (void)skipPhotoAlbumVC:(PhotoMode)mode;
@end
