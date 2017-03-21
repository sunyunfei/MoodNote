//
//  CreateCell.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
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
