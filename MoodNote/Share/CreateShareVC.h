//
//  CreateShareVC.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/12.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CreateShareVCDelegate <NSObject>

- (void)refreshShareVC;

@end
@interface CreateShareVC : UIViewController
@property(nonatomic,assign)id<CreateShareVCDelegate>delegate;
@end
