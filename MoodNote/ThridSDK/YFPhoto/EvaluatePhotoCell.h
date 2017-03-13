//
//  EvaluatePhotoCell.h
//  LiveYoung
//
//  Created by 孙云 on 16/9/13.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface EvaluatePhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) UIImageView *photoImage;
@property(nonatomic,strong)UIImage *photo;
@property(nonatomic,copy)NSString *urlStr;
@end
