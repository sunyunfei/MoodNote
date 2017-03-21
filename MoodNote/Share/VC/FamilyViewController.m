//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "FamilyViewController.h"
#import "FamilyGroupCell.h"
#import "ShowImageViewController.h"
#import "ReplyInputView.h"
#import "YFCommentModel.h"
#import "YFBmobManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CreateShareVC.h"
@interface FamilyViewController ()<CreateShareVCDelegate>
@property (nonatomic,strong)NSMutableArray *familyGroupData;
@property (nonatomic,weak)UIButton *replyButton; //点击后弹出的评论按钮
@property (nonatomic,weak)ReplyInputView *replyInputView;
@property (nonatomic,assign)BOOL flag;  //用于键盘出现时函数调用多次的情况
@property (weak, nonatomic) IBOutlet UITableView *familyTableView;

//用于view的移动，使评论框落在cell下面，没想到别的方法
@property (nonatomic,assign)float replyViewDraw;

//工具栏的高约束，用于当输入文字过多时改变工具栏的约束
@property (strong, nonatomic) NSLayoutConstraint *replyInputViewConstraintHeight;
@end

@implementation FamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseLoadTitle:@"心情分享" andShowLeft:NO andShowRight:YES andreturnTitle:@"创建"];
    
    [self addHeaderView];
    self.flag = YES;
    _familyGroupData = [NSMutableArray array];
    //获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //注册为被通知者
    [notificationCenter addObserver:self selector:@selector(keyChange:) name:UIKeyboardDidShowNotification object:nil];
    
    //下啦刷新
    __block typeof(self)weakSelf = self;
    self.familyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadData];
    }];
    //开始刷新
    [self.familyTableView.mj_header beginRefreshing];
}

- (void)baseRightBtn{

    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CreateShareVC" bundle:nil];
    CreateShareVC *vc = [story instantiateViewControllerWithIdentifier:@"create"];
    vc.title = @"分享心情";
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#define headViewHeight 200
#define headIconWidth 50
#define headIconHeight 50

#pragma mark ----UI设置
-(void)addHeaderView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headViewHeight)];
    
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headViewHeight - 2*padding)];
    backGroundImageView.image = [UIImage imageNamed:@"background.jpg"];
    [headView addSubview:backGroundImageView];
    
    
    UIImageView *headIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding, headViewHeight - headIconHeight, headIconWidth, headIconHeight)];
    headIconImageView.layer.cornerRadius = CGRectGetWidth(headIconImageView.frame) / 2;
    headIconImageView.layer.masksToBounds = YES;
    [headIconImageView sd_setImageWithURL:[NSURL URLWithString:[UserDataManager obtainUserIcon]]];
    [headView addSubview:headIconImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(headIconWidth + 2 * padding, headViewHeight - 0.8*headIconHeight, 100, 15)];
    nameLabel.text = [UserDataManager obtainUserName];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor whiteColor];
    [headView addSubview:nameLabel];
    
    self.familyTableView.tableHeaderView = headView;
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%lu",(unsigned long)[self.statusFrames count]);
    return self.familyGroupData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FamilyGroupCell *cell = [FamilyGroupCell cellWithTableView:tableView];
    cell.familyGroupFrame = self.familyGroupData[indexPath.row];
    [cell.replyButton addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.replyButton.tag = indexPath.row;
    //回复
    __block typeof(self)weakSelf = self;
    cell.labelBlock = ^(NSString *name,NSInteger row){
    
        [weakSelf initReplyInputView:row andName:name];
    };
    //评论时可以知道加到第几行
    cell.imageBlock = ^(NSArray *imageViews, NSInteger clickTag) {
        self.navigationController.navigationBarHidden = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
        [vc setHidesBottomBarWhenPushed:YES]; //隐藏tabbar
        vc.clickTag = clickTag;
        vc.imageViews = imageViews;
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    return cell;
}

-(void)loadData
{
    [_familyGroupData removeAllObjects];
    __block typeof(self)weakSelf = self;
    [YFBmobManager obtainShareData:^(NSMutableArray *dataArray) {
        //开始分享图片的请求
        
        for(NSInteger i =0;i < dataArray.count;i ++){
            
            FamilyGroup *model = dataArray[i];
            __block typeof(NSInteger)weakI = i;
            [YFBmobManager obtainShareImage:model.messageId success:^(NSMutableArray *imageArray) {
                
                model.pictures = imageArray;
                
                if (weakI == dataArray.count - 1) {
                    [weakSelf.familyGroupData removeAllObjects];
                    //说明到了最后
                    for (FamilyGroup *model in dataArray) {
                        
                        FamilyGroupFrame *familyGroupFrame = [[FamilyGroupFrame alloc]init];
                        familyGroupFrame.familyGroup = model;
                        [weakSelf.familyGroupData addObject:familyGroupFrame];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.familyTableView.mj_header endRefreshing];
                        [weakSelf.familyTableView reloadData];
                    });
                }
            } failure:^{
                NSLog(@"图片请求错误");
            }];
            
            [YFBmobManager obtainComment:model.messageId sucess:^(NSMutableArray *commentArray) {
                
                model.replys = commentArray;
                if (weakI == dataArray.count - 1) {
                    [weakSelf.familyGroupData removeAllObjects];
                    //说明到了最后
                    for (FamilyGroup *model in dataArray) {
                        
                        FamilyGroupFrame *familyGroupFrame = [[FamilyGroupFrame alloc]init];
                        familyGroupFrame.familyGroup = model;
                        [weakSelf.familyGroupData addObject:familyGroupFrame];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.familyTableView.mj_header endRefreshing];
                        [weakSelf.familyTableView reloadData];
                    });
                }
                
            } failure:^{
                NSLog(@"评论请求错误");
            }];
        }
        
    } failure:^{
        
        NSLog(@"失败");
    }];
}

-(void)replyAction:(UIButton *)sender
{
    FamilyGroupCell *cell = (FamilyGroupCell *)sender.superview.superview;
    
    self.replyViewDraw = [cell convertRect:cell.bounds toView:self.view.window].origin.y + cell.frame.size.height;
    
    NSIndexPath *indexPath = [self.familyTableView indexPathForCell:cell];
    CGRect rectInTableView = [self.familyTableView rectForRowAtIndexPath:indexPath];
    //NSLog(@"%f",rectInTableView.origin.y);
    CGRect replyButtonF = CGRectMake(sender.frame.origin.x , rectInTableView.origin.y+sender.frame.origin.y - 2, 0,20);
//    NSLog(@"%f",self.replyButton.frame.origin.y);
//    NSLog(@"%f",rectInTableView.origin.y+sender.frame.origin.y - 2);
    if (self.replyButton && self.replyButton.frame.origin.y != (rectInTableView.origin.y+sender.frame.origin.y - 2-padding)) {
        [self.replyButton removeFromSuperview];      //以防用户按了一个评论又按另一个
        self.replyButton = nil;
    }
    [self initReplyButton:replyButtonF];
    if (self.replyButton) {
        self.replyButton.tag = sender.tag;
    }
}

-(void)initReplyButton:(CGRect)replyButtonF
{
    if (!self.replyButton) {
        UIButton *replyButton = [UIButton buttonWithType:0];
        replyButton.layer.cornerRadius = 5;
        replyButton.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:1.0];
        replyButton.frame = replyButtonF;
        [replyButton setTitleColor:[UIColor whiteColor] forState:0];
        replyButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [replyButton addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self.familyTableView addSubview:replyButton];
        self.replyButton = replyButton;
        
        [UIView animateWithDuration:0.25f animations:^{
            CGRect replyButtonDurF;
            replyButtonDurF.size.height = replyButtonF.size.height + 2*padding;
            replyButtonDurF.origin.y = replyButtonF.origin.y - padding;
            replyButtonDurF.origin.x = replyButtonF.origin.x - 60;
            replyButtonDurF.size.width = 60;
            replyButton.frame = replyButtonDurF;
        } completion:^(BOOL finished) {
            [replyButton setTitle:@"评论" forState:0];
        }];
        
    }
    else
    {
        [UIView animateWithDuration:0.25f animations:^{
            self.replyButton.frame = replyButtonF;    //只是为了有收缩的动画效果
        } completion:^(BOOL finished) {
            [self.replyButton removeFromSuperview];
            self.replyButton = nil;
        }];
        
    }
}

-(void)replyMessage:(UIButton *)sender
{
    if (self.replyButton) {
        [self initReplyInputView:sender.tag andName:nil];
        [self.replyButton removeFromSuperview];
        self.replyButton = nil;
    }
}

-(void)initReplyInputView:(NSInteger) tag andName:(NSString *)name
{
    ReplyInputView *replyInputView = [[ReplyInputView alloc]initWithFrame:CGRectMake(0, self.view.bounds.origin.y + self.view.frame.size.height - 105, screenWidth, 54) andAboveView:self.view];
    
    self.flag = YES;
    //回调输入框的contentSize,改变工具栏的高度
    [replyInputView setContentSizeBlock:^(CGSize contentSize) {
        [self updateHeight:contentSize];
    }];
    
    [replyInputView setReplyAddBlock:^(NSString *replyText, NSInteger inputTag) {
        
        YFCommentModel *model = [[YFCommentModel alloc]init];
        model.commentUserName = [UserDataManager obtainUserName];
        //判断是否事回复
        if (name != nil && name.length > 0) {
            
            model.commentText = [NSString stringWithFormat:@"回复%@:%@",name,replyText];
        }else{
        
            model.commentText = replyText;
        }
        FamilyGroupFrame *familyGroupFrameNeedChanged = self.familyGroupData[inputTag];
        FamilyGroup *newFamilyGroup = familyGroupFrameNeedChanged.familyGroup;
        //做个中转
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:newFamilyGroup.replys];
        [mutaArray addObject:model];
        newFamilyGroup.replys = mutaArray;
        
        familyGroupFrameNeedChanged.replysF = nil;
        familyGroupFrameNeedChanged.picturesF = nil;
        familyGroupFrameNeedChanged.familyGroup = newFamilyGroup;
        //加入后台
        [YFBmobManager insertComment:newFamilyGroup.messageId andCommentModel:model sucess:^{
            
            NSLog(@"评论加入成功");
        } failure:^{
            
            
        }];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inputTag inSection:0];  //nsindexpath初始化方法
        [self.familyTableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];

    }];

    replyInputView.replyTag = tag;    //值为cell所在的行
    [self.view addSubview:replyInputView];
    self.replyInputView = replyInputView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FamilyGroupFrame *frame = self.familyGroupData[indexPath.row];
    return frame.cellHeight;
}

//更新replyView的高度约束
-(void)updateHeight:(CGSize)contentSize
{
    float height = contentSize.height + 20;
    CGRect frame = self.replyInputView.frame;
    frame.origin.y -= height - frame.size.height;  //高度往上拉伸
    frame.size.height = height;
    self.replyInputView.frame = frame;
}

//键盘出来的时候调整replyView的位置
-(void) keyChange:(NSNotification *) notify
{
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    if (keyboardRect.size.height >250 && self.flag) {
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            
            CGRect frame = self.replyInputView.frame;
            frame.origin.y = frame.origin.y - keyboardRect.size.height + 52;
            self.replyInputView.frame = frame;
            
            CGPoint point = self.familyTableView.contentOffset;
            
            point.y -= (frame.origin.y - self.replyViewDraw);
            self.familyTableView.contentOffset = point;
        }];
        self.flag = NO;

    }
}

- (void)refreshShareVC{


    //开始刷新
    [self.familyTableView.mj_header beginRefreshing];
    
}
@end
