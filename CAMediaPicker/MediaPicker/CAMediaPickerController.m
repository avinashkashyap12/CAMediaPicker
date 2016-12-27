//
//  CAMediaPickerController.m
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 11/28/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import "CAMediaPickerController.h"
#import "CAAlbumPickerViewController.h"
#import "CAVideoPickerController.h"

@interface CAMediaPickerController ()<ImageAlbumDelegate>
{
    MediaPickerSourceType mediaSource;
}
@end

@implementation CAMediaPickerController

-(instancetype) initMediaPickerWithOwnerController:(UIViewController *)controller{
    
    self = [super initWithRootViewController:[self getImageAlbumPickerController]];
    if (self) {
        ownerController = controller;
        //[ownerController addChildViewController:self];
        mediaSource = MediaPickerSourcePhotoTypeAlbum;
    }
    return self;
}
-(instancetype) initMediaPickerWithSource:(MediaPickerSourceType)source withOwnerController:(UIViewController *)controller{
    ownerController = controller;
    mediaSource = source;
    if((source == MediaPickerSourceTypeImage) || (source == MediaPickerSourceTypeVideo)){
        return [self init];
    }
    self = [super initWithRootViewController:[self getPickerRootControllerForSource:source]];
    if (self) {
    
    }
    return self;
}
-(UIViewController *) getPickerRootControllerForSource:(MediaPickerSourceType)source{
    if (source == MediaPickerSourceVideoTypeAlbum) {
        return [self getVideoPickerController];
    }
    else{
        return [self getImageAlbumPickerController];
    }
    return [self getImageAlbumPickerController];
}
#pragma mark -
-(void) displayImagePickerWithSource:(MediaPickerSourceType) source{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.view.tag = 1;
    //check source and set media
    if (source == MediaPickerSourceTypeVideo) {
        pickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        pickerController.view.tag = 2;
    }
    
    pickerController.delegate = self;
    pickerController.modalInPopover = NO;
    [ownerController presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark -
-(CAAlbumPickerViewController *) getImageAlbumPickerController{
    CAAlbumPickerViewController *albumPickerController = [[CAAlbumPickerViewController alloc] initWithNibName:@"CAAlbumPickerViewController" bundle:nil];
    albumPickerController.albumDelegate = self;
    return albumPickerController;
}
-(CAVideoPickerController *) getVideoPickerController{
    CAVideoPickerController *videoPickerController = [[CAVideoPickerController alloc] initWithNibName:@"CAVideoPickerController" bundle:nil];
    //albumPickerController.albumDelegate = self;
    return videoPickerController;
}
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) didCancelImageAlbumSelection{
    if(self.mediaPickerDelegate &&  [self.mediaPickerDelegate respondsToSelector:@selector(mediaPickerDidCacnel:)]){
        [self.mediaPickerDelegate mediaPickerDidCacnel:self];
    }
}
-(void) didSelectedAssetList:(NSArray *)assetList{
    if (self.mediaPickerDelegate && [self.mediaPickerDelegate respondsToSelector:@selector(mediaPicker:didSelectedAssets:)]) {
        [self.mediaPickerDelegate mediaPicker:self didSelectedAssets:assetList];
    }
}
#pragma mark -
-(void) presentMediaController{
    //[ownerController addChildViewController:self];
    if (mediaSource == MediaPickerSourceTypeVideo || mediaSource == MediaPickerSourceTypeImage) {
        [self displayImagePickerWithSource:mediaSource];
    }
    [ownerController presentViewController:self animated:YES completion:nil];
}
@end
