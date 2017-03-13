//
//  CreateCell.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/12.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCell : UICollectionViewCell
@property(nonatomic,copy)void(^deleBlock)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
- (IBAction)clickClearBtn:(UIButton *)sender;

@end
