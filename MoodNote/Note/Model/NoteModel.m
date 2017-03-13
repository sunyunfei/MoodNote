//
//  NoteModel.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/8.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel
- (instancetype)initWithBmob:(BmobObject *)bmob{

    self = [super init];
    if (self) {
        
        if ([bmob objectForKey:@"objectId"]) {
            self.note_id = [bmob objectForKey:@"objectId"];
        }
        if ([bmob objectForKey:@"user_id"]) {
            self.user_id = [bmob objectForKey:@"user_id"];
        }
        if ([bmob objectForKey:@"note_weather"]) {
            self.note_weather = [bmob objectForKey:@"note_weather"];
        }
        if ([bmob objectForKey:@"note_video"]) {
            self.note_video = [bmob objectForKey:@"note_video"];
        }
        if ([bmob objectForKey:@"note_type"]) {
            self.note_type = [bmob objectForKey:@"note_type"];
        }
        if ([bmob objectForKey:@"note_time"]) {
            self.note_time = [bmob objectForKey:@"note_time"];
        }
        if ([bmob objectForKey:@"note_location"]) {
            self.note_location = [bmob objectForKey:@"note_location"];
        }
        if ([bmob objectForKey:@"note_image"]) {
            self.note_image = [bmob objectForKey:@"note_image"];
        }
        if ([bmob objectForKey:@"note_content"]) {
            self.note_content = [bmob objectForKey:@"note_content"];
        }
        
    }
    return self;
}
@end
