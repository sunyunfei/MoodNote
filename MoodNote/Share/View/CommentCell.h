//
//  CommentCell.h
//  再防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFCommentModel.h"
@interface CommentCell : UITableViewCell
@property(nonatomic,strong)YFCommentModel *model;//数据
+(CGFloat)cellHeightForCell:(YFCommentModel *)model;
@end
