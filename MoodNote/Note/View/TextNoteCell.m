//
//  TextNoteCell.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "TextNoteCell.h"
@interface TextNoteCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//内容
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;//天气
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;//位置
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation TextNoteCell
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor greenColor].CGColor;
}
- (void)setModel:(NoteModel *)model{

    _model = model;
    self.contentLabel.text = model.note_content;
    self.timeLabel.text = model.note_time;
    self.weatherLabel.text = model.note_weather;
    self.locationLabel.text = model.note_location;
}
@end
