//
//  PhotoShowManager.m
//  YangLiWu
//
//  Created by 孙云 on 16/9/6.
//  Copyright © 2016年 haidai. All rights reserved.
//

#import "PhotoShowManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
@interface PhotoShowManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end
@implementation PhotoShowManager
//单类
+ (instancetype)sharePhotoManager{

    static PhotoShowManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PhotoShowManager alloc]init];
    });
    return manager;
}

//跳转相册
- (void)skipPhotoAlbumVC:(PhotoMode)mode{

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    picker.allowsEditing            = YES;
    switch (mode) {
        case X_C_MODE:
            picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case X_J_MODE:
            picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
            break;
        case S_P_MODE:
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
            picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像
            picker.mediaTypes=@[(NSString *)kUTTypeMovie];
            picker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
            picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频
            picker.videoMaximumDuration = 8.0f;//最多12秒
            break;
        default:
            break;
    }
    
    [[self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController] presentViewController:picker animated:YES completion:NULL];
}

//获取顶层的vc
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是视频
    
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        //显示
        [self ZIPVideo:url VideoName:[NSString stringWithFormat:@"%@.mp4",[self getTimeNow]]];
        
        //保存视频的第一帧图片
        UIImage *image = [self getVideoPreViewImage:url];
        [self saveImage:image];
        //显示视频图片
        if (self.iconBlock) {
            self.iconBlock(image);
        };
        
    }else{
    
       UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        //图片传递
        if(self.iconBlock){
            
            self.iconBlock(image);
        }
        
        
        [self saveImage:image];
    }
    
    //处理完毕，回到个人信息页面
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


//保存图片
- (void)saveImage:(UIImage *)tempImage
{
    [MBProgressHUD YFshowHUD:[UIApplication sharedApplication].keyWindow.rootViewController.view labelText:@"转换中"];
    //测试用
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    
    //上传图片
    NSString *fileName = [NSString stringWithFormat:@"http://%@.jpg",[self getTimeNow]];

    //图片上传
    __block typeof(self)weakSelf = self;
    [YFBmobManager updateDataToBMOB:imageData andName:fileName success:^(NSString *url) {
        
        if (weakSelf.updateBlock) {
            weakSelf.updateBlock(url);
            NSLog(@"图片上传成功");
            [MBProgressHUD YFhiddenOldHUDandShowNewHUD:[UIApplication sharedApplication].keyWindow.rootViewController.view newText:@"格式转换成功"];
        }
    } failure:^{
        [MBProgressHUD YFhiddenOldHUDandShowNewHUD:[UIApplication sharedApplication].keyWindow.rootViewController.view newText:@"格式转换失败"];
    }];
}


//获取第一帧图片
- (UIImage*) getVideoPreViewImage:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);

    return img;
}
#pragma mark ===视频压缩======
- (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   blockHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(session);
         
         //播放路径
         
     }];
}

//压缩视频
-(void)ZIPVideo:(NSURL *)inputURl VideoName:(NSString *)videoName{
    
    //设置录制视频保存的路径
    NSString *outpath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",videoName]];
    
    //转为视频保存的url
    NSURL *outurl  = [NSURL fileURLWithPath:outpath];
    __block typeof(self)weakSelf = self;
    [self lowQuailtyWithInputURL:inputURl outputURL:outurl blockHandler:^(AVAssetExportSession *session)
     {
         if (session.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"压缩成功");
             //上传到服务器
             [YFBmobManager updateDataToBMOB:[NSData dataWithContentsOfURL:outurl] andName:videoName success:^(NSString *url) {
                 
                 NSLog(@"视频上传bmob成功");
                 if (weakSelf.updateBlock) {
                     weakSelf.updateVideoBlock(url);
                 }
                 
             } failure:^{
                 NSLog(@"图片上传失败");
             }];
         }
         else
         {
             NSLog(@"压缩失败");
             
         }
     }];
}


//压缩图片尺寸
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

/**
 *  返回当前时间
 *
 */
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    //NSLog(@"%@", timeNow);
    return timeNow;
}

@end
