//
//  AddNote.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "BaseVC.h"
#import "NoteModel.h"
@protocol AddNoteDelegate <NSObject>
- (void)refreshDataForRoot;//刷新数据
@end
@interface AddNote : BaseVC
@property(nonatomic,weak)id<AddNoteDelegate>delegate;
//数据
@property(nonatomic,strong)NoteModel *oldModel;
@end
