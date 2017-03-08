//
//  NoteVC.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/5.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "NoteVC.h"
#import "TextNoteCell.h"
#import "AddNote.h"
static NSString *textCell = @"TextNoteCell";
@interface NoteVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *noteTableView;//表格
@property(nonatomic,strong)NSMutableArray *noteArray;//数据
- (IBAction)clickAddBtn:(id)sender;//添加日记事件
@end

@implementation NoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_loadNoteArray];
    [self p_loadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----ui处理
//加载表格
- (void)p_loadTableView{

    _noteTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _noteTableView.delegate = self;
    _noteTableView.dataSource = self;
    _noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_noteTableView registerNib:[UINib nibWithNibName:textCell bundle:nil] forCellReuseIdentifier:textCell];
    [self.view addSubview:_noteTableView];
}

#pragma mark----数据加载
- (void)p_loadNoteArray{

    _noteArray = [NSMutableArray arrayWithArray:[UIFont familyNames]];
}

#pragma mark ----事件
//添加日记
- (IBAction)clickAddBtn:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddNote" bundle:nil];
    AddNote *addVC = [story instantiateViewControllerWithIdentifier:@"add"];
    [self.navigationController pushViewController:addVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark ----代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.noteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TextNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
@end
