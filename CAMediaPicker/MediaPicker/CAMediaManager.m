//
//  CAMediaManager.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAMediaManager.h"


@implementation CAMediaManager

+(CAMediaManager *) sharedMediaManagerWithRootController:(UIViewController *)controller{
    return [[self alloc] initWithController:controller];
}
-(instancetype) initWithController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        if (controller != nil) {
            ownerController = controller;
            mediaPickerManager = self;
           // [ownerController addChildViewController:self];
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:mediaPickerManager];
        }
        
    }
    return self;
}
#pragma mark - Authorization
-(PHAuthorizationStatus) getAuthorizationStatus{
    return [PHPhotoLibrary authorizationStatus];
}
-(void) requestUserForAuthorization{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
    }];
}
- (void)photoLibraryDidChange:(PHChange *)changeInstance{
    NSLog(@"did change");
   PHAuthorizationStatus status = [self getAuthorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:mediaPickerManager];
        [self presentMediaPickerControllerWithSource:self.mediaPickerSource];
    }
}
#pragma mark -
-(void) presentMediaPickerControllerWithSource:(MediaPickerSourceType)source{
    PHAuthorizationStatus status = [self getAuthorizationStatus];
    self.mediaPickerSource = source;
    //check authorization
    if (status == PHAuthorizationStatusNotDetermined) {
        [self requestUserForAuthorization];
        return;
    }
    if (status != PHAuthorizationStatusAuthorized) {
        if (self.mediaPickerDelegate && [self.mediaPickerDelegate respondsToSelector:@selector(mediaPicker:didFailWithAuthorizationStatus:)]) {
            [self.mediaPickerDelegate mediaPicker:self didFailWithAuthorizationStatus:status];
        }
        return;
    }
    //display picker
    if (source == MediaPickerSourceTypeImage || source == MediaPickerSourceTypeVideo) {
        [self displayImagePickerControllerWithSource:source];
    }
    else if (source == MediaPickerSourceVideoTypeAlbum){
        [self displayVideoAlbumPicker];
    }
    else{
        [self displayImageAlbumPicker];
    }
}
#pragma mark -
-(void) displayImageAlbumPicker{
    CAAlbumPickerViewController *albumPickerController = [[CAAlbumPickerViewController alloc] initWithNibName:@"CAAlbumPickerViewController" bundle:nil];
    albumPickerController.albumDelegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:albumPickerController];
    [ownerController presentViewController:navCon animated:YES completion:nil];
}
-(void) displayVideoAlbumPicker{
    CAVideoPickerController *videoPicker = [[CAVideoPickerController alloc] initWithNibName:@"CAVideoPickerController" bundle:nil];
    videoPicker.videoPickerDelegate = self;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:videoPicker];
    [ownerController presentViewController:navCon animated:YES completion:nil];
}
#pragma mark -
-(void) displayImagePickerControllerWithSource:(MediaPickerSourceType)source{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.view.tag = 1;
    //check source and set media
    if (source == MediaPickerSourceTypeVideo) {
        pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        pickerController.view.tag = 2;
    }
    
    pickerController.delegate = mediaPickerManager;
    pickerController.modalInPopover = NO;
    [ownerController presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark - Image Picker Delegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"perform selection");
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (picker.view.tag == 1) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        if(self.mediaPickerDelegate && [self.mediaPickerDelegate respondsToSelector:@selector(mediaPicker:didSelectedAssets:)]){
            [self.mediaPickerDelegate mediaPicker:self didSelectedAssets:@[image]];
        }
    }
    else if (picker.view.tag == 2){
        NSString *videoUrlStr = [NSString stringWithFormat:@"%@",info[UIImagePickerControllerMediaURL]];
        videoUrlStr = [videoUrlStr stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        if(self.mediaPickerDelegate && [self.mediaPickerDelegate respondsToSelector:@selector(mediaPicker:didSelectedAssets:)]){
            [self.mediaPickerDelegate mediaPicker:self didSelectedAssets:@[videoUrlStr]];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"Cancel media selection");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self sendCancelDelegateMessage];
}
-(void) sendCancelDelegateMessage{
    if (self.mediaPickerDelegate && [self.mediaPickerDelegate respondsToSelector:@selector(didCancelMediaPicker:)]) {
        [self.mediaPickerDelegate didCancelMediaPicker:self];
    }
}
#pragma mark - Album Picker Delegate
-(void) didCancelImageAlbumPicker:(CAAlbumPickerViewController *)albumPicker{
    [albumPicker dismissViewControllerAnimated:YES completion:nil];
    [self sendCancelDelegateMessage];
}
-(void) albumPicker:(CAAlbumPickerViewController *)albumPicker didSelectedAssetList:(NSArray *)assetList{
    [albumPicker dismissViewControllerAnimated:YES completion:nil];
    [self sendMediaSelectionDelegate:assetList];
}

#pragma mark - Video Picker Delegate
-(void) didCancelVideoPicker:(CAVideoPickerController *)videoPicker{
    [videoPicker dismissViewControllerAnimated:YES completion:nil];
    [self sendCancelDelegateMessage];
}
-(void) vidoePicker:(CAVideoPickerController *)videoPicker didSelectedMedia:(NSString *)videoUrl{
    dispatch_async(dispatch_get_main_queue(), ^{
        [videoPicker dismissViewControllerAnimated:YES completion:nil];
    });
    
    [self sendMediaSelectionDelegate:@[videoUrl]];
}
-(void) sendMediaSelectionDelegate:(NSArray *)assetList{
    if (self.mediaPickerDelegate && [self.mediaPickerDelegate respondsToSelector:@selector(mediaPicker:didSelectedAssets:)]) {
        [self.mediaPickerDelegate mediaPicker:self didSelectedAssets:assetList];
    }
}
@end
