//
//  ViewController.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 11/28/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>
#import "CAAlbumPickerViewController.h"
#import "CAMediaManager.h"
#import "CAActivityIndicatorView.h"
#import "ImageThumbnailCollectionViewCell.h"
#import "ImageViewController.h"


@interface ViewController ()<MediaPickerDelegate>
{
    CAActivityIndicatorView *caActivityIndicator;
}
@end

@implementation ViewController
-(void) displayActivityIndicator{
    if (!caActivityIndicator) {
        caActivityIndicator = [[CAActivityIndicatorView alloc] initWithFrame:self.view.frame];
    }
    [self.view addSubview:caActivityIndicator];
    [caActivityIndicator setMessageText:@"Exporting video"];
    [caActivityIndicator displayActivityIndicatorView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //-----------
    [self.listCollectionView registerClass:[ImageThumbnailCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark -
#pragma mark CollectionView Delegate and Datasource
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionList.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(100, 130);
    }
    return CGSizeMake(75.5, 75.5);
}
-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    NSDictionary *dict = [self.collectionList objectAtIndex:indexPath.row];
    if ([dict[@"Type"] isEqualToString:@"Video"]) {
        cell.iconImageView.image = [UIImage imageNamed:@"video_icon.png"];
        cell.thumbnailImageView.image = [self createThunbnailImage:[NSURL URLWithString:dict[@"Asset"]]];
    }
    else{
        cell.iconImageView.image = [UIImage imageNamed:@"image_icon.png"];
        cell.thumbnailImageView.image = dict[@"Asset"];
    }
    
    return cell;
}
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.collectionList objectAtIndex:indexPath.row];
    if ([dict[@"Type"] isEqualToString:@"Video"]){
        [self playVideo:dict[@"Asset"]];
    }
    else{
        [self displayAssets:indexPath.row];
    }
    
}
-(void) displayAssets:(NSInteger)index{
    NSDictionary *dict = [self.collectionList objectAtIndex:index];
    ImageViewController *imageController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil withImage:dict[@"Asset"]];
    [self.navigationController pushViewController:imageController animated:YES];
    
}
#pragma mark -
-(UIImage *) createThunbnailImage:(NSURL *)url{
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMake(1, 1);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    return thumbnail;
}
#pragma mark - Display Picker
-(IBAction) buttonAction:(UIButton *)sender{
    
    [self displayPicker:sender.tag];
}
#pragma mark -
-(void) displayPicker:(NSInteger)tagValue{
    if (tagValue == 0) {
        NSLog(@"Display image picker");
        [self displayPickerWithSource:MediaPickerSourcePhotoTypeAlbum];
    }
    else if (tagValue == 1){
        NSLog(@"display video picker");
        [self displayPickerWithSource:MediaPickerSourceVideoTypeAlbum];
    }
    else if (tagValue == 2){
        [self displayPickerWithSource:MediaPickerSourceTypeImage];
    }
    else{
        [self displayPickerWithSource:MediaPickerSourceTypeVideo];
    }
}
#pragma mark - Display CAMediaPicker
-(void) displayPickerWithSource:(MediaPickerSourceType)source{
    
    CAMediaManager *mediaManager = [CAMediaManager sharedMediaManagerWithRootController:self];
    mediaManager.mediaPickerDelegate = self;
    [mediaManager presentMediaPickerControllerWithSource:source];
}
#pragma mark - Media Picker
-(void) didCancelMediaPicker:(CAMediaManager *)mediaPicker{
    NSLog(@"Cancel media selection");
}
-(void) mediaPicker:(CAMediaManager *)mediaPicker didSelectedAssets:(NSArray *)assetList{
    NSLog(@"Selected assets count = %zd", assetList.count);
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < assetList.count; i++){
        if(mediaPicker.mediaPickerSource == MediaPickerSourceTypeVideo || mediaPicker.mediaPickerSource == MediaPickerSourceVideoTypeAlbum){
            [tempArray addObject:@{@"Type":@"Video",@"Asset":assetList[i]}];
        }
        else{
            [tempArray addObject:@{@"Type":@"Image",@"Asset":assetList[i]}];
        }
    }
    self.collectionList = [NSArray arrayWithArray:tempArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.listCollectionView reloadData];
    });
    
}
-(void) mediaPicker:(CAMediaManager *)mediaPicker didFailWithAuthorizationStatus:(PHAuthorizationStatus)status{
    if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"Application not having access to use photo album and camera");
    }
    
}
#pragma mark -
-(void) playVideo:(NSString *)path{
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    AVPlayerViewController * playerController = [[AVPlayerViewController alloc] init];
    playerController.player = player;
    [player performSelector:@selector(play) withObject:nil afterDelay:0.5];
    [self presentViewController:playerController animated:YES completion:nil];
}

@end
