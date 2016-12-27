//
//  CAMediaManager.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaPickerDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#import "CAAlbumPickerViewController.h"
#import "CAVideoPickerController.h"

typedef NS_ENUM (NSInteger, MediaPickerSourceType){
    MediaPickerSourceTypeImage,
    MediaPickerSourceTypeVideo,
    MediaPickerSourcePhotoTypeAlbum,
    MediaPickerSourceVideoTypeAlbum
};

@interface CAMediaManager : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageAlbumDelegate, VideoPickerDelegate, PHPhotoLibraryChangeObserver>
{
    UIViewController *ownerController;
    CAMediaManager *mediaPickerManager;
}
+(CAMediaManager *) sharedMediaManagerWithRootController:(UIViewController *)controller;
-(void) presentMediaPickerControllerWithSource:(MediaPickerSourceType)source;

@property (nonatomic, assign) MediaPickerSourceType mediaPickerSource;
@property (nonatomic, weak) id <MediaPickerDelegate> mediaPickerDelegate;
@end
