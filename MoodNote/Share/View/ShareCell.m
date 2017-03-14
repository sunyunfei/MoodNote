//
//  ShareCell.m
//  再防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "ShareCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ImageCell.h"
#import "CommentCell.h"
#import "InputView.h"
static NSString *cell_comment = @"CommentCell";
static NSString *cell_image = @"ImageCell";
@interface ShareCell()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIImageView *icon;//头像
@property(nonatomic,strong)UILabel *nameLabel;//名字
@property(nonatomic,strong)UILabel *timeLabel;//时间
@property(nonatomic,strong)UILabel *contentLabel;//内容
@property(nonatomic,strong)UICollectionView *collectionView;//图片显示
@property(nonatomic,strong)UIButton *commentBtn;//评论图片
@property(nonatomic,strong)UITableView *commentTableView;//评论内容
@property(nonatomic,strong)InputView *inputView;//输入框
@end
@implementation ShareCell

//构造
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //ui创建
        _icon = [[UIImageView alloc]init];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blueColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:cell_image bundle:nil] forCellWithReuseIdentifier:cell_image];
        [self.contentView addSubview:_collectionView];
        
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBtn.backgroundColor = [UIColor redColor];
        [_commentBtn addTarget:self action:@selector(clickCommentBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentBtn];
        
        _commentTableView = [[UITableView alloc]init];
        _commentTableView.bounces = NO;
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.backgroundColor = [UIColor yellowColor];
        [_commentTableView registerClass:[CommentCell class] forCellReuseIdentifier:cell_comment];
        [self.contentView addSubview:_commentTableView];
    }
    return self;
}

//按钮事件
- (void)clickCommentBtn{

    //评论
    [self loadInputView:New_Comment];
    _inputView.messageModel = self.rectManager.messageModel;
}

- (void)setRectManager:(YFShareRectManager *)rectManager{

    _rectManager = rectManager;
    YFMessageModel *model = rectManager.messageModel;
    //数据赋予
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.nameLabel.text = model.userName;
    self.timeLabel.text = model.timeTag;
    self.contentLabel.text = model.message;
    [self setUIFrame];
    
}

- (void)setUIFrame{

    _icon.frame = self.rectManager.iconRect;
    self.nameLabel.frame = self.rectManager.nameRect;
    self.timeLabel.frame = self.rectManager.timeRect;
    self.contentLabel.frame = self.rectManager.contentRect;
    self.collectionView.frame = self.rectManager.imageRect;
    self.commentTableView.frame = self.rectManager.commentRect;
    self.commentBtn.frame = self.rectManager.commentBtnRect;
    
    if (self.rectManager.messageModel.messageSmallPics.count > 0) {
        
        [self setLayout];
        [self.collectionView reloadData];
    }else{
        
        //[self.collectionView removeFromSuperview];
    }
    
    
    [self.commentTableView reloadData];
}

//家在输入框
- (void)loadInputView:(NSInteger)mode{

    if (_inputView) {
        [_inputView removeFromSuperview];
        _inputView = nil;
    }
    _inputView = [[InputView alloc]init];
    _inputView.mode = mode;
    __block typeof(self)weakSelf = self;
    _inputView.refreshBlock = ^(YFMessageModel *model){
    
        weakSelf.rectManager.messageModel = model;
        
        if (weakSelf.refreshCell) {
            weakSelf.refreshCell(weakSelf.indexPath);
        }
    };
    [_inputView showInWindows];
}

#pragma mark ----九宫格
- (void)setLayout{

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat w = CGRectGetWidth(self.collectionView.frame);
    if(w <= 0){
    
        w = 10;
    }
    layout.itemSize = CGSizeMake(w/4.0,70);
    NSLog(@"item = %.2f---%.2f",layout.itemSize.width,layout.itemSize.width);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView setCollectionViewLayout:layout];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.rectManager.messageModel.messageSmallPics.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_image forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.rectManager.messageModel.messageSmallPics[indexPath.row]]];
    return cell;
}


#pragma mark----评论表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.rectManager.messageModel.commentModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_comment forIndexPath:indexPath];
    cell.model = self.rectManager.messageModel.commentModelArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    YFCommentModel *model = self.rectManager.messageModel.commentModelArray[indexPath.row];
    return [CommentCell cellHeightForCell:model];
}

//评论点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self loadInputView:Replay_Mode];
    _inputView.messageModel = self.rectManager.messageModel;
    _inputView.commentModel = self.rectManager.messageModel.commentModelArray[indexPath.row];
}
@end
