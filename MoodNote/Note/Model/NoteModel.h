//
//  NoteModel.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/8.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface NoteModel : NSObject
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *note_weather;
@property(nonatomic,copy)NSString *note_video;
@property(nonatomic,copy)NSString *note_time;
@property(nonatomic,copy)NSString *note_location;
@property(nonatomic,copy)NSString *note_image;
@property(nonatomic,copy)NSString *note_id;
@property(nonatomic,strong)NSNumber *note_type;
@property(nonatomic,copy)NSString *note_content;

- (instancetype)initWithBmob:(BmobObject *)bmob;
@end
