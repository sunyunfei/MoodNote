//
//  PhotoNoteView.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "PhotoNoteView.h"

@implementation PhotoNoteView

//加载
+ (instancetype)loadPhotoView{

    return [[[NSBundle mainBundle]loadNibNamed:@"PhotoNoteView" owner:self options:nil] lastObject];
}
@end
