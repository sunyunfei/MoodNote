//
//  CreateShareVC.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "BaseVC.h"
@protocol CreateShareVCDelegate <NSObject>

- (void)refreshShareVC;

@end
@interface CreateShareVC : BaseVC
@property(nonatomic,assign)id<CreateShareVCDelegate>delegate;
@end
