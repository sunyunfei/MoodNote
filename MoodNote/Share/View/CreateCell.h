//
//  CreateCell.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCell : UICollectionViewCell
@property(nonatomic,copy)void(^deleBlock)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
- (IBAction)clickClearBtn:(UIButton *)sender;

@end
