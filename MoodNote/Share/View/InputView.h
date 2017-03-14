//
//  InputView.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFMessageModel.h"
#import "YFCommentModel.h"
typedef NS_ENUM(NSInteger,dataMode){

    Replay_Mode,//回复
    New_Comment//新建
};
@interface InputView : UIView
@property(nonatomic,assign)NSInteger mode;//模式
@property(nonatomic,strong)YFMessageModel *messageModel;
@property(nonatomic,strong)YFCommentModel *commentModel;
@property(nonatomic,copy)void(^refreshBlock)(YFMessageModel *model);
- (void)showInWindows;
@end
