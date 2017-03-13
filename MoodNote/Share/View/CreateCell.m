//
//  CreateCell.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/12.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "CreateCell.h"

@implementation CreateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)clickClearBtn:(UIButton *)sender {
    
    if (self.deleBlock) {
        self.deleBlock(sender.tag);
    }
}
@end
