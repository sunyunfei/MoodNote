//
//  ShowNoteVC.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/9.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "ShowNoteVC.h"
#import "AddNote.h"
@interface ShowNoteVC (){

    CGFloat contentY;//内容的y值
}
@property(nonatomic,strong)UILabel *contentLabel;//内容
@property(nonatomic,strong)UIImageView *imageView;//图片或者视频
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *weatherLabel;//天气
@property(nonatomic,strong)UILabel *locationLabel;//位置
@property(nonatomic,strong)UIScrollView *scrollView;//滑动背景
@end

@implementation ShowNoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //默认的内容的y位置
    contentY = 10;
    [self p_loadEditBtn];
    [self p_loadScrollView];
    [self p_LoadLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNoteModel:(NoteModel *)noteModel{

    _noteModel = noteModel;
    
    //判断类别
    switch ([noteModel.note_type intValue]) {
        case 0:
        {
        
            //图片
            [self p_loadImageView];
            
            [self p_setRectForLabel];
            //图片赋予
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteModel.note_image]];
        }
            break;
        case 1:{
        
            //视频
            //图片
            [self p_loadImageView];
            
            [self p_setRectForLabel];
            //图片赋予
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:noteModel.note_image]];
        }
            break;
        case 2:{
        
            //文字
            [self p_setRectForLabel];
        }
            break;
        default:
            break;
    }
    
    self.contentLabel.text = noteModel.note_content;
    self.timeLabel.text = noteModel.note_time;
    self.weatherLabel.text = noteModel.note_weather;
    self.locationLabel.text = noteModel.note_location;
}

#pragma mark ----加载ui
//修改按钮的添加
- (void)p_loadEditBtn{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(clickEditBtn)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)p_loadScrollView{

    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_scrollView];
}
//加载imageView
- (void)p_loadImageView{

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, contentY, CGRectGetWidth(self.view.frame), 200)];
    self.imageView.backgroundColor = [UIColor redColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:self.imageView];
    contentY = contentY + CGRectGetHeight(self.imageView.frame);
}

//加载内容
- (void)p_LoadLabel{

    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.backgroundColor = [UIColor yellowColor];
    self.contentLabel.font = [UIFont systemFontOfSize:16];
    self.contentLabel.numberOfLines = 0;
    [_scrollView addSubview:self.contentLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.weatherLabel = [[UILabel alloc]init];
    self.weatherLabel.font = [UIFont systemFontOfSize:12];
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:self.timeLabel];
    [_scrollView addSubview:self.weatherLabel];
    [_scrollView addSubview:self.locationLabel];
}

//位置布局
- (void)p_setRectForLabel{

    CGSize contentSize = [self.noteModel.note_content boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    self.contentLabel.frame = CGRectMake(8, contentY, contentSize.width, contentSize.height);
    
    self.timeLabel.frame = CGRectMake(8, contentY + contentSize.height + 8, CGRectGetWidth(self.view.frame) - 16, 20);
    self.locationLabel.frame = CGRectMake(8, CGRectGetHeight(self.timeLabel.frame) + self.timeLabel.frame.origin.y + 8, CGRectGetWidth(self.view.frame) - 16, 20);
    self.weatherLabel.frame = CGRectMake(8, CGRectGetHeight(self.locationLabel.frame) + self.locationLabel.frame.origin.y + 8, CGRectGetWidth(self.view.frame) - 16, 20);
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), self.weatherLabel.frame.origin.y + CGRectGetHeight(self.weatherLabel.frame));
}

#pragma mark ----事件
//修改
- (void)clickEditBtn{

    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddNote" bundle:nil];
    AddNote *addVC = [story instantiateViewControllerWithIdentifier:@"add"];
    addVC.oldModel = self.noteModel;
    [self.navigationController pushViewController:addVC animated:YES];

}
@end
