//
//  NoteVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/5.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "NoteVC.h"
#import "TextNoteCell.h"
#import "AddNote.h"
#import "PhotoNoteCell.h"
#import "ShowNoteVC.h"
static NSString *textCell = @"TextNoteCell";
static NSString *photoCell = @"PhotoNoteCell";
@interface NoteVC ()<UITableViewDelegate,UITableViewDataSource,AddNoteDelegate>
@property(nonatomic,strong)UITableView *noteTableView;//表格
@property(nonatomic,strong)NSMutableArray *noteArray;//数据
@end

@implementation NoteVC

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseLoadTitle:@"心情日记" andShowLeft:NO andShowRight:YES andreturnTitle:@"创建"];
    self.noteArray = [NSMutableArray array];
    
    [self p_loadTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataForRoot) name:@"refreshNote" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)baseRightBtn{

    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"AddNote" bundle:nil];
    AddNote *addVC = [story instantiateViewControllerWithIdentifier:@"add"];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark ----ui处理
//加载表格
- (void)p_loadTableView{

    _noteTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight - 44)];
    _noteTableView.delegate = self;
    _noteTableView.dataSource = self;
    _noteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_noteTableView registerNib:[UINib nibWithNibName:textCell bundle:nil] forCellReuseIdentifier:textCell];
    [_noteTableView registerNib:[UINib nibWithNibName:photoCell bundle:nil] forCellReuseIdentifier:photoCell];
    [self.view addSubview:_noteTableView];
    
    self.noteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self p_loadNoteArray];
    }];
    
    [self.noteTableView.mj_header beginRefreshing];
}

#pragma mark----数据加载
- (void)p_loadNoteArray{

    [self.noteArray removeAllObjects];
    __block typeof(self)weakSelf = self;
    [YFBmobManager queryNoteDataSuccess:^(NSMutableArray *noteArray) {
        
        weakSelf.noteArray = noteArray;
        //表刷新
        [weakSelf.noteTableView reloadData];
        [weakSelf.noteTableView.mj_header endRefreshing];
        
    } failure:^{
        
        [weakSelf.noteTableView.mj_header endRefreshing];
    }];
}

#pragma mark ----事件

#pragma mark ----代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.noteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //首先判断
    NoteModel *noteModel = self.noteArray[indexPath.row];
    if ([noteModel.note_type intValue] == 2) {
        //说明是文字
        TextNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:textCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.noteArray[indexPath.row];
        return cell;
    }else{
    
        PhotoNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.noteArray[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NoteModel *noteModel = self.noteArray[indexPath.row];
    if ([noteModel.note_type intValue] == 2) {
    
        return 100;
    }else
    return 140;
}

//删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{

    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //开始删除
        [MBProgressHUD YFshowHUD:self.view labelText:@"删除中..."];
        NoteModel *model = self.noteArray[indexPath.row];
        [self.noteArray removeObjectAtIndex:indexPath.row];
        [YFBmobManager deleteNoteData:model.note_id success:^{
            
            [MBProgressHUD YFhiddenHUD:self.view];
            [self.noteTableView reloadData];
        } failure:^{
            [MBProgressHUD YFhiddenOldHUDandShowNewHUD:self.view newText:@"删除失败"];
        }];
    }
}

//查看
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NoteModel *model = self.noteArray[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    ShowNoteVC *vc = [[ShowNoteVC alloc]init];
    vc.noteModel = model;
    vc.title = @"笔记详情";
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//刷新数据
- (void)refreshDataForRoot{

    [self.noteTableView.mj_header beginRefreshing];
}
@end
