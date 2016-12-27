//
//  CAMediaPickerController.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 11/28/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPickerDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>

typedef NS_ENUM (NSInteger, MediaPickerSourceType){
    MediaPickerSourceTypeImage,
    MediaPickerSourceTypeVideo,
    MediaPickerSourcePhotoTypeAlbum,
    MediaPickerSourceVideoTypeAlbum
};

@interface CAMediaPickerController : UINavigationController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIViewController *ownerController;
}
-(instancetype) initMediaPickerWithOwnerController:(UIViewController *)controller;
-(instancetype) initMediaPickerWithSource:(MediaPickerSourceType)source withOwnerController:(UIViewController *)controller;
-(void) presentMediaController;
@property (nonatomic, weak) id <MediaPickerDelegate> mediaPickerDelegate;
@end
