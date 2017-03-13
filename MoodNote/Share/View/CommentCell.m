//
//  CommentCell.m
//  再防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "CommentCell.h"
#define K_MARGAIN 8//边界
#define K_WIDTH [UIScreen mainScreen].bounds.size.width//总宽
#define K_HEIGH [UIScreen mainScreen].bounds.size.height//总高
@interface CommentCell()
@property(nonatomic,strong)UILabel *commentLabel;
@end
@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _commentLabel = [[UILabel alloc]init];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.numberOfLines = 0;
        _commentLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}

- (void)setModel:(YFCommentModel *)model{

    _model = model;
    
    CGFloat contentX = K_MARGAIN * 2 + 30;
    NSMutableString *comment = [NSMutableString string];
    if (model.commentByUserId) {
        
        //说明是回复的评论的
        [comment appendString:[NSString stringWithFormat:@"%@回复%@:",model.commentUserName,model.commentByUserName]];
        [comment appendString:model.commentText];
        
    }else{
        
        [comment appendString:[NSString stringWithFormat:@"%@:",model.commentUserName]];
        [comment appendString:model.commentText];
    }
    //开始计算
    CGSize commentSize = [comment boundingRectWithSize:CGSizeMake(K_WIDTH -K_MARGAIN-contentX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.commentLabel.text = comment;
    self.commentLabel.frame = CGRectMake(contentX, 0, commentSize.width, commentSize.height);
    
    
}

//总高度
+(CGFloat)cellHeightForCell:(YFCommentModel *)model{

    CGFloat contentX = K_MARGAIN * 2 + 30;
    NSMutableString *comment = [NSMutableString string];
    if (model.commentByUserId) {
        
        //说明是回复的评论的
        [comment appendString:[NSString stringWithFormat:@"%@回复%@:",model.commentUserName,model.commentByUserName]];
        [comment appendString:model.commentText];
        
    }else{
        
        [comment appendString:[NSString stringWithFormat:@"%@:",model.commentUserName]];
        [comment appendString:model.commentText];
    }
    //开始计算
    CGSize commentSize = [comment boundingRectWithSize:CGSizeMake(K_WIDTH -K_MARGAIN-contentX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return commentSize.height;
}
@end
