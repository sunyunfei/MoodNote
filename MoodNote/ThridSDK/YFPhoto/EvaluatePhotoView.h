//
//  EvaluatePhotoView.h
//  LiveYoung
//
//  Created by 孙云 on 16/9/13.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,showPhotoMode){

    showLocationMode,//本地图片
    showURLMode//网络图片
};

@interface EvaluatePhotoView : UIView
@property(nonatomic,assign)NSInteger modeShow;//显示的模式
@property(nonatomic,strong)NSMutableArray *photoArray;//photo
@property(nonatomic,assign)NSInteger sectionIndex;//选择的图片处于的段
@property(nonatomic,assign)NSInteger indexTag;//选择的图片的下标值
@end
