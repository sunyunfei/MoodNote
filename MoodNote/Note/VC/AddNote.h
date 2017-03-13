//
//  AddNote.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
@protocol AddNoteDelegate <NSObject>
- (void)refreshDataForRoot;//刷新数据
@end
@interface AddNote : UIViewController
@property(nonatomic,weak)id<AddNoteDelegate>delegate;
//数据
@property(nonatomic,strong)NoteModel *oldModel;
@end
