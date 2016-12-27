//
//  CAVideoPickerController.h
//  CAMediaPicker
//
//  Created by Avinash Kashyap on 12/19/16.
//  Copyright © 2016 Headerlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>

@protocol VideoPickerDelegate;

@interface CAVideoPickerController : UIViewController
@property (nonatomic, strong)  NSMutableArray *allVideoAssetArray;
@property (nonatomic, weak) IBOutlet UICollectionView *listCollectionView;
@property (nonatomic, weak) id <VideoPickerDelegate> videoPickerDelegate;
@end
@protocol VideoPickerDelegate <NSObject>

-(void) didCancelVideoPicker:(CAVideoPickerController *)videoPicker;
-(void) vidoePicker:(CAVideoPickerController *)videoPicker didSelectedMedia:(NSString *)videoUrl;

@end
