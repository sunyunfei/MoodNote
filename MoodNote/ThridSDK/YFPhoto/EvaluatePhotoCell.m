//
//  EvaluatePhotoCell.m
//  LiveYoung
//
//  Created by 孙云 on 16/9/13.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "EvaluatePhotoCell.h"

@interface EvaluatePhotoCell()<UIScrollViewDelegate>
@property(nonatomic,assign)CGFloat totalScale;//原始尺寸
@end
@implementation EvaluatePhotoCell

- (void)awakeFromNib{

    [super awakeFromNib];
    self.totalScale = 1.0;
    
    self.photoScrollView.maximumZoomScale = 2.5;
    self.photoScrollView.minimumZoomScale = 1.0;
    self.photoScrollView.delegate = self;

    self.photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 55)];

    self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.photoScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 55);
    [self.photoScrollView addSubview:self.photoImage];
    

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImage;
}

- (void)setPhoto:(UIImage *)photo{

    if (photo != nil && ![photo isKindOfClass:[NSNull class]]) {
       self.photoImage.image = photo;
    }
}

- (void)setUrlStr:(NSString *)urlStr{

    _urlStr = urlStr;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}
@end
