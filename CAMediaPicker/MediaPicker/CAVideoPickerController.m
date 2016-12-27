//
//  CAVideoPickerController.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAVideoPickerController.h"
#import "ImageThumbnailCollectionViewCell.h"
#import "CAActivityIndicatorView.h"

@interface CAVideoPickerController ()
{
    CAActivityIndicatorView *caActivityIndicator;
}
@end

@implementation CAVideoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Videos";
    [self.listCollectionView registerClass:[ImageThumbnailCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [self addLeftNavigationBarButton];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getMediaList];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(void) addLeftNavigationBarButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBarButtonAction:)];
}
-(void) cancelBarButtonAction:(UIBarButtonItem *)sender{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self sendDismissDelegateMessage];
}
-(void) addRightBarButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelBarButtonAction:)];
}
-(void) sendDismissDelegateMessage{
    if (self.videoPickerDelegate && [self.videoPickerDelegate respondsToSelector:@selector(didCancelVideoPicker:)]) {
        [self.videoPickerDelegate didCancelVideoPicker:self];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma  mark - get list of videos
-(void) getMediaList{
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    PHFetchResult *assetResults = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    for (PHAsset *asset in assetResults){
        //NSLog(@"asset type = %zd", asset.mediaType);
        [assets addObject:asset];
    }
    self.allVideoAssetArray = [[NSMutableArray alloc] init];
    PHImageManager *manager = [PHImageManager defaultManager];
    for(PHAsset *asset in assets){
        
        [manager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            //NSURL *url = (NSURL *)[[(AVURLAsset *)avAsset URL] fileReferenceURL];
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                NSURL *url = (NSURL *)[[(AVURLAsset *)asset URL] fileReferenceURL];
                UIImage *thumbnail = [self createThunbnailImage:url];
                [self.allVideoAssetArray addObject:@{@"VideoUrl":url,@"ThumbnailImage":thumbnail, @"VideoAsset":asset}];
                if (assets.count == self.allVideoAssetArray.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.allVideoAssetArray.count<=0) {
                            self.listCollectionView.hidden = YES;
                            //self.messageLabel.hidden = NO;
                        }
                        else{
                            self.listCollectionView.hidden = NO;
                            //self.messageLabel.hidden = YES;
                            [self.listCollectionView reloadData];
                        }
                        //[self.indicatorView stopAnimating];
                    });
                }
                
            }
        }];
    }
}
-(UIImage *) createThunbnailImage:(NSURL *)url{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    return thumbnail;
}
#pragma mark -
#pragma mark CollectionView Delegate and Datasource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allVideoAssetArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(100, 130);
    }
    return CGSizeMake(75.5, 75.5);
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    cell.thumbnailImageView.image = [self.allVideoAssetArray objectAtIndex:indexPath.row][@"ThumbnailImage"];
    cell.iconImageView.image = [UIImage imageNamed:@"video_icon.png"];
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self exportVideo:[self.allVideoAssetArray objectAtIndex:indexPath.row][@"VideoAsset"]];
    
}
-(void) playVideoOnPath:(NSURL *)url{
    // NSURL *url = [NSURL fileURLWithPath:path];//get video data
    NSString *str = [NSString stringWithFormat:@"%@",url];
    str = [str stringByReplacingOccurrencesOfString:@"file://" withString:@"/private"];
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:str]];
    videoData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@",str]];
    
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerViewController * playerController = [[AVPlayerViewController alloc] init];
    playerController.player = player;
    [player performSelector:@selector(play) withObject:nil afterDelay:0.5];
    [self presentViewController:playerController animated:YES completion:nil];
}
#pragma mark -
-(void) displayActivityIndicator{
    if (!caActivityIndicator) {
        caActivityIndicator = [[CAActivityIndicatorView alloc] initWithFrame:self.navigationController.view.frame];
    }
    [self.navigationController.view addSubview:caActivityIndicator];
    [caActivityIndicator setMessageText:@"Exporting video"];
    [caActivityIndicator displayActivityIndicatorView];
}
#pragma mark -
-(void) exportVideo:(AVAsset *)asset{
    [self displayActivityIndicator];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *videoPath = [self getfileName];
        NSURL *fileURL = [NSURL fileURLWithPath:videoPath];
        __block NSData *assetData = nil;
        
        // asset is you AVAsset object
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
        
        exportSession.outputURL = fileURL;
        // e.g .mov type
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            assetData = [NSData dataWithContentsOfURL:fileURL];
            [caActivityIndicator hideActivityIndicatorView];
            if (assetData==nil) {
                NSLog(@"nil respo");
                [self displayAlertMessage:@"Unable to export video, please try again"];
                return;
            }
            NSLog(@"AVAsset saved to NSData.");
            if (self.videoPickerDelegate && [self.videoPickerDelegate respondsToSelector:@selector(vidoePicker: didSelectedMedia:)]) {
                [self.videoPickerDelegate vidoePicker:self didSelectedMedia:videoPath];
            }
        }];
    });
    
}
#pragma mark -
-(void) displayAlertMessage:(NSString *)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          
      }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -
#pragma mark Get UUID
-(NSString *) generateUniqueIdentifier{
    CFUUIDRef theUniqueString = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUniqueString);
    CFRelease(theUniqueString);
    NSString *uuidString = (__bridge NSString *)string;
    CFRelease(string);
    return uuidString;
}
-(NSString *) getfileName{
    NSString *unique_id = [self generateUniqueIdentifier];
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MOV",unique_id]];
    return filepath;
}
@end
