//
//  PhotoNoteCell.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "PhotoNoteCell.h"
#import <AVFoundation/AVFoundation.h>
@interface PhotoNoteCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;//视频
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;//图片
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;//位置
@property (weak, nonatomic) IBOutlet UIView *bgView;//背景色

@end
@implementation PhotoNoteCell

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderWidth = 3;
}

- (void)setModel:(NoteModel *)model{

    _model = model;
    self.contentLabel.text = model.note_content;
    self.timeLabel.text = model.note_time;
    self.weatherLabel.text = model.note_weather;
    self.locationLabel.text = model.note_location;
    //判断是视频还是图片
    if ([model.note_type intValue] == 0) {
        
        self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else{
    
        //是视频
        self.bgView.layer.borderColor = [UIColor blueColor].CGColor;
    }
    //图片
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.note_image]];
}

@end
