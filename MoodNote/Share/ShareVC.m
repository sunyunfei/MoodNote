//
//  ShareVC.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/12.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "ShareVC.h"
#import "CreateShareVC.h"
#import "YFShareRectManager.h"
#import "YFBmobManager.h"
#import "YFMessageModel.h"
#import "ShareCell.h"
static NSString *cell_now = @"ShareCell";
@interface ShareVC ()<UITableViewDelegate,UITableViewDataSource,CreateShareVCDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据
- (IBAction)clickShareBtn:(id)sender;

@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
     _dataArray = [NSMutableArray array];
    [self p_loadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickShareBtn:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CreateShareVC" bundle:nil];
    CreateShareVC *vc = [story instantiateViewControllerWithIdentifier:@"create"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark ----UI
//表加载
- (void)p_loadTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[ShareCell class] forCellReuseIdentifier:cell_now];
    __block typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf p_loadData];
    }];
    [self.view addSubview:_tableView];
    [self.tableView.mj_header beginRefreshing];
}

//数据
- (void)p_loadData{
    
    [_dataArray removeAllObjects];
    __block typeof(self)weakSelf = self;
    [YFBmobManager obtainShareData:^(NSMutableArray *dataArray) {
        //开始分享图片的请求
        
        for(NSInteger i =0;i < dataArray.count;i ++){
            
            YFMessageModel *model = dataArray[i];
            __block typeof(NSInteger)weakI = i;
            [YFBmobManager obtainShareImage:model.message_id success:^(NSMutableArray *imageArray) {
                
                model.messageSmallPics = imageArray;
                
                if (weakI == dataArray.count - 1) {
                    [weakSelf.dataArray removeAllObjects];
                    //说明到了最后
                    for (YFMessageModel *model in dataArray) {
                        
                        YFShareRectManager *manager = [[YFShareRectManager alloc]init];
                        manager.messageModel = model;
                        [weakSelf.dataArray addObject:manager];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.tableView reloadData];
                    });
                }
            } failure:^{
                NSLog(@"图片请求错误");
            }];
            
            [YFBmobManager obtainComment:model.message_id sucess:^(NSMutableArray *commentArray) {
                
                [model.commentModelArray addObjectsFromArray:commentArray];
                if (weakI == dataArray.count - 1) {
                    [weakSelf.dataArray removeAllObjects];
                    //说明到了最后
                    for (YFMessageModel *model in dataArray) {
                        
                        YFShareRectManager *manager = [[YFShareRectManager alloc]init];
                        manager.messageModel = model;
                        [weakSelf.dataArray addObject:manager];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.tableView.mj_header endRefreshing];
                        [weakSelf performSelector:@selector(reloadDataForTableView) withObject:weakSelf afterDelay:1.0];
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

-(void)reloadDataForTableView{

    
    [self.tableView reloadData];
}

#pragma mark ---代理

- (void)refreshShareVC{

    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_now forIndexPath:indexPath];
    cell.rectManager = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    __block typeof(self)weakSelf = self;
    cell.refreshCell = ^(NSIndexPath *path){
    
        [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YFShareRectManager *manager = self.dataArray[indexPath.row];
    return manager.allHeight;
}
@end
